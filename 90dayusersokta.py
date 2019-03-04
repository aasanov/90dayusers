import json, requests

url = 'https://leoconnect-admin.okta.com/api/v1/users'
head = {"Accept":"application/json",
        "Content-type": "application/json",
        "Authorization": "SSWS 008ZJ34_gPsZk0pertZqamOERjpGm7VV6pJNn8hZCW"}
paramaters = {"filter": "status eq \"ACTIVE\""}

req = json.loads(requests.get(url,params=paramaters,headers=head).content)

count = 0

for user in req:
    print(user['id'])
    count = count + 1

print(count)
