import json, requests

url = 'https://admin.okta.com/api/v1/users'
head = {"Accept":"application/json",
        "Content-type": "application/json",
        "Authorization": "here will be your authorization key"}
paramaters = {"filter": "status eq \"ACTIVE\""}

req = json.loads(requests.get(url,params=paramaters,headers=head).content)

count = 0

for user in req:
    print(user['id'])
    count = count + 1

print(count)
