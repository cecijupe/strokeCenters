var express = require('express');
var path = require('path');
var app = express();
var bodyParser = require('body-parser');
app.use(bodyParser.urlencoded());
app.use(bodyParser.json());
app.set('port', (process.env.PORT || 7000));
// app.use(express.static(__dirname));
app.use(express.static(path.join(__dirname,'client')));
var server = app.listen(app.get('port'), function() {
	console.log("stoke at port: 7000")
});
var hospital = { 
	strokeCenter: [{
			key: "UW",
			name: "UW Medicine/Northwest",
			available: false},
			{
			key: "VMMC",
			name: "Virginia Mason Medical Center",
			available: false
		}, {
			key: "SMC",
			name: "Swedish Medical Center",
			available: false
		}, {
			key: "SMCCH",
			name: "Swedish Medical Center/Cherry Hill",
			available: false
		}, {
			key: "HMC",
			name: "Harborview Medical Center",
			available: false
		}
	]
}
var updateAva = function(){
	var avaArr = [];
	for (center in hospital.strokeCenter) {
		avaArr.push(hospital.strokeCenter[center].available)
	}
	return avaArr
};
var io = require('socket.io').listen(server);
io.sockets.on('connection', function(socket){
	console.log("socket connected ", socket.id);
	socket.on("embulanceLogged", function(data){
		console.log("embulance logged in")
		var updateInfo = updateAva();
		console.log(updateInfo);
		socket.emit("updateHospitalAv", updateInfo);
	})
	socket.on("requestSent", function(data){
		data.socketID = socket.id;
		console.log("request sent", data);
		socket.broadcast.emit('thereWasRequest', data);
	});
	socket.on("responseForRequest", function(data){
		console.log("response for request ", data)
		var embSocket = data[1];
		console.log(embSocket)
		if (io.sockets.connected[embSocket]){
			console.log("emitting")
			io.sockets.connected[embSocket].emit('hospitalResponse', data[0])
		}
	});
	socket.on('disconnect', function(){
		console.log("socket disconnected",socket.id);
	});
	socket.on("availability", function(data){
		console.log("availability socket triggerred", data)
		for (center in hospital.strokeCenter) {
			console.log(hospital.strokeCenter[center].key);
			if (hospital.strokeCenter[center].key == data[0]){
				console.log("changing the availability of", hospital.strokeCenter[center].key);
				hospital.strokeCenter[center].available = data[1];
				var updateInfo = updateAva();
				socket.broadcast.emit("updateHospitalAv", updateInfo);
			}
		}
		console.log(hospital);
	});
	socket.on("notifyHospital", function(hospitalKey){
		console.log(hospitalKey);
		var data = [hospitalKey, String(socket.id)];
		socket.broadcast.emit("notifySentToHospital", data);
	})

// 	console.log("socket connected", socket.id);
// 	socket.on("startedChat", function(data){
// 		console.log(data)
// 		users.find(data, socket);
// 		// var xxx = "chris"
// 		// console.log(receiver);
// 		// io.sockets.emit('receiver',xxx);
// 	});
// 	socket.on('updateSocketID', function(data){
// 		data.cSocketID = socket.id;
// 		console.log(data, "data");
// 		users.updateSocketID(data, function(){
// 			for (var friend = 0; friend < data.friends.length; friend++){

// 				if (data.friends[friend].cSocketID){
// 					var friendSocketID = data.friends[friend].cSocketID;
// 					console.log("emitting to friend", friendSocketID)
// 					if (io.sockets.connected[friendSocketID]){
// 						console.log("emitting")
// 						io.sockets.connected[friendSocketID].emit('updateFriendList', data)
// 					}
// 				}
// 				console.log(1, data.friends[friend].cSocketID, friend, data.friends.length)
// 			}
// 		});

// 	});
// 	socket.on('disconnect', function(){
// 		users.disconnectSocket(socket.id);
// 	});
// 	socket.on('sendMessageToServer', function(data){
// 		console.log("sendmessage",data,"from socket id ",socket.id)
// 		if(data.sendTo){
// 			if (io.sockets.connected[data.sendTo]){
// 				console.log("really emitting the message to ", data.sendTo)
// 				io.sockets.connected[data.sendTo].emit('message', data);
// 			}
// 		}

// 	})
})
