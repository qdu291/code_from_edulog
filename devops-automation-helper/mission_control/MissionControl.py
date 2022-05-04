from fire import Fire
import requests
import json
import random
import string


class MissionControl:

  def __init__(self, env: str = 'nonprod'):
    self.token = ''
    # Default variables of nonprod
    self.athena_client_id = 'bfb086b8-d053-4d57-8418-65436141564f'
    self.headers = {
      'apikey': '9d6c3f85669a40cd1b1fa4635b049b92bb04c881',
      'Content-Type': 'application/json'
    }
    self.url = 'https://athenagateway-p01-demo.usw2.karrostech.net/api'
    self.signin_content = '{"clientId":"9d6c3f85669a40cd1b1fa4635b049b92bb04c881","clientSecret":"ea055e01da75e03fd9bed34b26a187b5a652879a92d813a51934983b4383d38f","grantType":"resource_owner","scope":"Insight","email":"router@edulog.com","password":"edulog360"}'
    
    if env == 'prod':
      self.url = 'https://athenagateway-p01-prod.usw1.karrostech.net/api'
      self.signin_content = '{"clientId":"9d6c3f85669a40cd1b1fa4635b049b92bb04c881","clientSecret":"ea055e01da75e03fd9bed34b26a187b5a652879a92d813a51934983b4383d38f","grantType":"resource_owner","scope":"Mission Control","email":"admin@karrostech.com","password":"!karrosTech360admin!"}'
    

  def generate_password(self, length: int):
    letters_and_digits = string.ascii_letters + string.digits
    password = ''.join((random.choice(letters_and_digits) for i in range(length)))
    return password

  def get_response(self, resp):
    if resp.ok:
      content = json.loads(resp.content)
      if content:
        return content
    raise Exception(resp.reason)

  def signin(self):
    try:
      url = f'{self.url}/v1/signin'
      token = ''

      resp = requests.post(url=url, data=self.signin_content, headers=self.headers)
      content = self.get_response(resp)
      if content:
        token = content.get('accessToken')
        if token:
          self.headers['Authorization'] = f'Bearer {token}'
      return token

    except Exception as err:
      print(err)
      exit(1)
    

  def get_tenant_settings(self, tenant_id: str):
    try:
      url = f'{self.url}/v1.0/tenantsettings/{tenant_id}'
      
      self.signin()
      resp = requests.get(url=url, headers=self.headers)
      content = self.get_response(resp)
      return content

    except Exception as err:
      print(err)
      exit(1)
    

  def create_tenant(self, tenant_name: str, timezone: str):
    try:
      tenant = {}
      url = f'{self.url}/v2/mc/tenants'
      data = {
        'active': True,
        'ingestions': [],
        'name': tenant_name,
        'samsaraIntegrations': [],
        'tenantTimezone': timezone,
        'zonarIntegrations': [],
      }

      self.signin()
      resp = requests.post(url=url, headers=self.headers, data=json.dumps(data))
      
      content = self.get_response(resp)
      if content:
        tenant['id'] = content['content'].get('id')
        tenant['name'] = content['content'].get('name')
        if not tenant['id']:
          raise Exception(content.get('serviceMessage'))
      return tenant.get('id')
    except Exception as err:
      print(err)
      exit(1)


  def create_settings(self, tenant_id: str, timezone: str, settings: str = ''):
    try:
      if not settings:
        # Default Settings
        settings = '[{"settingType":"ADDRESS_MATCHING_PRIORITY","settingValue":"C"},{"settingType":"DRIVER_DIRECTIONS","settingValue":"GOOGLE"},{"settingType":"DYNAMIC_FREQUENCY_ALLOWED","settingValue":"STATIC"},{"settingType":"NUM_ROLLING_DATA_AREAS","settingValue":"1"},{"settingType":"WALK_DIST_CALC","settingValue":"GOOGLE"}]'
      url = f'{self.url}/v2.0/tenantsettings/athena/{tenant_id}'
      tenant_settings = json.loads(settings)

      if settings:
        self.signin()
        for setting in tenant_settings:
          resp = requests.post(url=url, headers=self.headers, data=json.dumps(setting))
      
          content = self.get_response(resp)
        # Create setting VEHICLE_COMMON_VISIBILITY
        url = f'{self.url}/v1.0/tenantsettings'
        setting = {
          "settingType": "VEHICLE_COMMON_VISIBILITY",
          "timezoneName": timezone,
          "dateTimeWindows": [
            {
              "dayOfWeekLocal": "U",
              "timeWindows": [
                {
                  "fromTimeLocal": "00:00",
                  "toTimeLocal": "24:00"
                }
              ]
            },
            {
              "dayOfWeekLocal": "M",
              "timeWindows": [
                {
                  "fromTimeLocal": "00:00",
                  "toTimeLocal": "24:00"
                }
              ]
            },
            {
              "dayOfWeekLocal": "T",
              "timeWindows": [
                {
                  "fromTimeLocal": "00:00",
                  "toTimeLocal": "24:00"
                }
              ]
            },
            {
              "dayOfWeekLocal": "W",
              "timeWindows": [
                {
                  "fromTimeLocal": "00:00",
                  "toTimeLocal": "24:00"
                }
              ]
            },
            {
              "dayOfWeekLocal": "R",
              "timeWindows": [
                {
                  "fromTimeLocal": "00:00",
                  "toTimeLocal": "24:00"
                }
              ]
            },
            {
              "dayOfWeekLocal": "F",
              "timeWindows": [
                {
                  "fromTimeLocal": "00:00",
                  "toTimeLocal": "24:00"
                }
              ]
            },
            {
              "dayOfWeekLocal": "S",
              "timeWindows": [
                {
                  "fromTimeLocal": "00:00",
                  "toTimeLocal": "24:00"
                }
              ]
            }
          ],
          "tenantId": tenant_id
        }
        resp = requests.post(url=url, headers=self.headers, data=json.dumps(setting))
        content = self.get_response(resp)
        
    except Exception as err:
      print(err)
      exit(1)

  def create_user(self, email: str, first_name: str, last_name: str, tenant_id: str):
    try: 
      default_password = self.generate_password(16)
      url = f'{self.url}/v2/mc/accounts'
      user_data = {
        "firstName": first_name,
        "lastName": last_name,
        "username": email,
        "email": email,
        "password": default_password,
        "enabled": "true",
        "emailVerified": "true"
      }
      user_id = ''

      self.signin()
      # Create User
      resp = requests.post(url=url, headers=self.headers, data=json.dumps(user_data))
      content = self.get_response(resp)
      print('create_user.content', content)
      if content:
        user_id = content['content'].get('id')
        print('create_user.password', default_password)
      else:
        raise Exception("UserCreation Failed!")  

      if user_id:
        # Assign Scopes
        url = f'{self.url}/v2/mc/accounts/{user_id}/client/{self.athena_client_id}/roles'
        
        scope_athena_admin = [{"id":"cb953626-5fa7-424b-9045-0e2e08d7d026","name":"Admin","description": None,"scopeParamRequired": None,"composite": False,"composites": None,"clientRole": True,"containerId":"bfb086b8-d053-4d57-8418-65436141564f","attributes":None}]
        requests.post(url=url, headers=self.headers, data=json.dumps(scope_athena_admin))

        # Assign Tenant
        ## Get list of tenants
        tenant_name = 'chiefleschi-wa'
        name = tenant_name.upper() + f'_{tenant_id}'
        group_id = ''
        url = f'{self.url}/v2/mc/accounts/groups'
        resp = requests.get(url=url, headers=self.headers)
        content = self.get_response(resp)
        if content:
          list_tenants = content['content'].get('groups')
          if list_tenants:
            tenant = list(filter(lambda t: t['name'] == name, list_tenants)) 
            if len(tenant) > 0:
              group_id = tenant[0].get('id')

        ## Assign Tenant to User
        if group_id:
          url = f'{self.url}/v2/mc/accounts/{user_id}/groups'
          user_data = [{"id":group_id,"name":name,"path":name,"attributes":None,"realmRoles":None,"clientRoles":None,"subGroups":[],"access":None}]
          requests.post(url=url, headers=self.headers, data=json.dumps(user_data))
      
      return user_id
    except Exception as err:
      print(err)
      exit(1)

if __name__ == "__main__":
  Fire(MissionControl)