#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p "python3.withPackages(ps: [ ps.botocore ])"

import botocore
import botocore.session
import botocore.exceptions

import configparser
import os
import platform
import subprocess
import sys
import time
import webbrowser

def get_creds_path():
  if platform.system() == 'Windows':
    user_profile = os.environ['USERPROFILE'].replace('\\', '/')
    return f"{user_profile}/.aws/credentials"
  return f"{os.environ['HOME']}/.aws/credentials"

def get_config_path():
  if platform.system() == 'Windows':
    user_profile = os.environ['USERPROFILE'].replace('\\', '/')
    return f"{user_profile}/.aws/ssofresh.ini"
  return f"{os.environ['HOME']}/.aws/ssofresh.ini"


def get_access_token(start_url, region):
  session=botocore.session.get_session()

  oidc_client = session.create_client(
    'sso-oidc',
    region_name = region
  )

  oidc_client_reg = oidc_client.register_client(
    clientName = 'ssofresh',
    clientType = 'public'
  )

  client_id = oidc_client_reg['clientId']
  client_secret = oidc_client_reg['clientSecret']

  device_auth = oidc_client.start_device_authorization(
    clientId = client_id,
    clientSecret = client_secret,
    startUrl = start_url
  )

  signin_url=device_auth['verificationUriComplete']
  webbrowser.open(signin_url)
  print(f"If your browser doesn't open automatically, navigate to: {signin_url}")

  while True:
    print('Polling ... ')
    try:
      token_response = oidc_client.create_token(
        clientId=client_id,
        clientSecret=client_secret,
        grantType='urn:ietf:params:oauth:grant-type:device_code',
        deviceCode=device_auth['deviceCode']
      )
      if 'accessToken' in token_response:
        break
    except botocore.exceptions.ClientError as e:
      time.sleep(2)

  access_token = token_response['accessToken']
  return access_token

def main():
  # Fetch the config
  configPath = get_config_path()

  config = configparser.ConfigParser()
  config.read(configPath)

  awscreds = configparser.ConfigParser()
  awscreds.read(get_creds_path())

  if len(sys.argv) < 2:
    print("Did you specify an account? Usage: 'ssofresh your_sso_profile_name'")
    return

  # Work out which account(s) we want refreshed
  profileName = sys.argv[1]
  print(f"Fetching for profile '{profileName}'")

  try:
    profiles = config[profileName]['profiles'].split(',')
    start_url = config[profileName]['start_url']
    region = config[profileName]['region']
  except:
    print(f"Error retrieving config from ssofresh.ini file - is {configPath} present and correct?")
    sys.exit()

  # Get an access token
  access_token = get_access_token(start_url, region)

  session=botocore.session.get_session()
  sso_client = session.create_client(
    'sso',
    region_name=region
  )

  # Get role credentials for each account
  for profile in profiles:
    account_id = config[profile]['account_id']
    role = config[profile]['role']
    role_creds = sso_client.get_role_credentials(
      roleName = role,
      accountId = account_id,
      accessToken = access_token
    )

    if not awscreds.has_section(profile):
      awscreds.add_section(profile)

    awscreds[profile]['aws_access_key_id'] = role_creds['roleCredentials']['accessKeyId']
    awscreds[profile]['aws_secret_access_key'] = role_creds['roleCredentials']['secretAccessKey']
    awscreds[profile]['aws_session_token'] = role_creds['roleCredentials']['sessionToken']

    print(f"Acct: {account_id}")
    print(f"\texport AWS_PROFILE={profile}")

  # Write them into the aws creds file
  with open(get_creds_path(), 'w') as credsfile:
    awscreds.write(credsfile)

main()
