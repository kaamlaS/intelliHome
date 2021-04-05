from flask import Flask
from flask import request
from pymongo import MongoClient
from bson.json_util import dumps
 
app = Flask(__name__)
 
client = MongoClient("")
db = client['kaamla']
HA = db['homeauto']
 
@app.route('/AddDevice')
def AddDevice():
    device = request.args['DeviceName']
    character = request.args['Character']
    group = request.args.get('GroupName')
    if(group ==None):
        HA.insert_one({'DeviceName':device,'Character':str(character),'count':0,'Status':'false'})  #add switch without group
        HA.update_one({'DeviceName':device},{'$unset':{'GroupName':''}})
        return 'device added'
    else:
        HA.insert_one({'DeviceName':device,'Character':str(character),'GroupName':group,'count':0,'Status':'false'})
        return 'device added'
 
 
 
@app.route('/AddGroup')
def AddGroup():
    group = request.args['GroupName']
    device1=request.args['Device1']
    device2=request.args.get('Device2')
    device3=request.args.get('Device3')
    device4=request.args.get('Device4')
    if(device2 == None ):
        print('1')
        HA.find_one_and_update({'DeviceName':device1},{'$set':{'GroupName':group}})
        return 'group added'
    elif(device3 == None):
        print('2')
        HA.find_one_and_update({'DeviceName':device1},{'$set':{'GroupName':group}})
        HA.find_one_and_update({'DeviceName':device2},{'$set':{'GroupName':group}})
        return 'group added'
    elif(device4==None):
        print('3')
        HA.find_one_and_update({'DeviceName':device1},{'$set':{'GroupName':group}})
        HA.find_one_and_update({'DeviceName':device2},{'$set':{'GroupName':group}})
        HA.find_one_and_update({'DeviceName':device3},{'$set':{'GroupName':group}})
        return 'group added'
    else:
        print('4')
        HA.find_one_and_update({'DeviceName':device1},{'$set':{'GroupName':group}})
        HA.find_one_and_update({'DeviceName':device2},{'$set':{'GroupName':group}})
        HA.find_one_and_update({'DeviceName':device3},{'$set':{'GroupName':group}})
        HA.find_one_and_update({'DeviceName':device4},{'$set':{'GroupName':group}})
        return 'group added'
 
@app.route('/TurnSwitchoff')
def TurnSwitchoff():
    switch = request.args['DeviceName']
    HA.find_one_and_update({'DeviceName':switch},{'$set':{'Status':'false'}})
    return 'false'
 
 
@app.route('/TurnGroupoff')
def TurnGroupoff():
    group = request.args['GroupName']
    HA.update_many({'GroupName':group},{'$set':{'Status':'false'}})
    return 'false'
 
 
@app.route('/TurnAllOn')
def TurnAllOn():
    HA.update_many({},{'$inc':{'count':1},'$set':{'Status':'true'}})
    return 'true'
 
@app.route('/switches')
def switches():
    switch = request.args['switch']
    data = HA.find_one({'DeviceName': switch})
    try:
        return data['Status']
    except:
        return ""
 
@app.route('/TurnAllOff')
def TurnAllOff():
    HA.update_many({},{'$set':{'Status':'false'}})
    return 'false'
 
 
@app.route('/FindGroup')
def FindGroup():
    group = request.args['GroupName']
    cursor = HA.find({'GroupName': group})
    return dumps(cursor)
 
 
@app.route('/IncGroup')
def IncGroup():
    x = request.args['GroupName']
    HA.update_many({'GroupName':x},{'$inc':{'count':1},'$set':{'Status':'true'}})
    return 'true'
 
 
@app.route('/IncSwitch')
def IncSwitch():
    x = request.args['DeviceName']
    HA.update_one({'DeviceName':x},{'$inc':{'count':1},'$set':{'Status':'true'}})
    return 'true'
 
 
@app.route('/DeleteSwitch')
def DeleteSwitch():
    x = request.args['DeviceName']
    HA.find_one_and_delete({'DeviceName':x})
    return 'deleted'
 
 
@app.route('/DeleteGroup')
def DeleteGroup():
    x = request.args['GroupName']
    print("hello")
    HA.update_many({'GroupName':x},{'$unset':{'GroupName':''}})
    return 'what'
 
 
@app.route('/FindSwitch')
def FindSwitch():
    x = request.args['DeviceName']
    res= HA.find_one({'DeviceName':x})
    res['_id']= "nigga"
    return res
 
 
@app.route('/')
def helloq():
    return "call on a route"
 
 
@app.route('/FindGroupsToMap')
def FindGroupsToMap():
    x = HA.distinct('GroupName')
    return dumps(x)
 
 
@app.route('/FindSwitches')
def FindSwitches():
    x= HA.find().sort([("count", -1)]).limit(6)
    return dumps(x)
 
 
if __name__ == '__main__':
    app.run(debug=True)

    
