fs = require('fs');
function ExtractABI(jsonname) {
	jsoncontent = require(__dirname+'/build/contracts/'+jsonname+'.json');
	fs.writeFile(jsonname+'.abi',JSON.stringify(jsoncontent.abi),function (err) {});
}
ExtractABI('OurCrowdsale');
ExtractABI('CrowdsaleToken');
ExtractABI('MainToken');

