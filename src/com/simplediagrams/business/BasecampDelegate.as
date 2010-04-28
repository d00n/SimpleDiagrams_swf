package com.simplediagrams.business
{
	import com.simplediagrams.model.BasecampModel;
	import com.simplediagrams.model.DiagramModel;
	import com.simplediagrams.model.vo.PersonVO;
	import com.simplediagrams.util.Logger;
	
	import flash.utils.ByteArray;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.http.HTTPService;
	import mx.utils.Base64Encoder;

	public class BasecampDelegate 
	{
		[Autowire(bean="basecampService")]
		public var service:HTTPService;
		
		[Autowire(bean="basecampModel")]
		public var basecampModel:BasecampModel;
		
		[Autowire(bean="diagramModel")]
		public var diagramModel:DiagramModel;
				
		
		private var _token:AsyncToken
		
		public function BasecampDelegate()
		{
			
		}
		
		public function cancelServiceCall():void
		{
			service.cancel()
		}
		public function getProjects():AsyncToken
		{						
			Logger.debug("getProjects()",this)
			service.url = basecampModel.basecampURL + "/projects"
			service.method = "GET"
			addAuthHeader(service)
			service.contentType="application/x-www-form-urlencoded"
			service.headers["Accept"] = "application/xml"	
			service.resultFormat = "e4x"
			return service.send()
		}
		
		public function getPeople():AsyncToken
		{						
			Logger.debug("getPeople()",this)
			service.url = basecampModel.basecampURL + "/people"
			service.method = "GET"
			addAuthHeader(service)
			service.contentType="application/x-www-form-urlencoded"
			service.headers["Accept"] = "application/xml"	
			service.resultFormat = "e4x"
			return service.send()
		}
		
		public function uploadImage(ba:ByteArray):AsyncToken
		{
			Logger.debug("sendMessage()", this)
			addAuthHeader(service)
			service.url = basecampModel.basecampURL + "/upload"
			service.method = "POST"
			service.contentType="application/octet-stream"
			service.resultFormat = "e4x"
			return service.send(ba)
			
		}
			
		
		public function sendMessage(messageTitle:String, messageBody:String, extendedMessageBody:String, imageUploadID:String, projectID:String):AsyncToken
		{
			Logger.debug("sendMessage() imageUploadID: " + imageUploadID, this)
			addAuthHeader(service)
			service.url = basecampModel.basecampURL + "/projects/"+ projectID + "/posts.xml"
			service.contentType="application/xml"	
			var msgXML:XML = <request>
								  <post>
									<title></title>
									<body></body>
									<extended-body></extended-body>
									<private>1</private> <!-- only for firm employees -->
								  </post>
								  <attachments>
									  <name>SimpleDiagram</name>
									  <file>
									    <file></file>    
										<content-type>image/png</content-type>
    									<original-filename>my_simple_diagram.png</original-filename>
									  </file>
									</attachments>
								</request>
			
			msgXML.post.title = messageTitle
			msgXML.post.body = messageBody
			msgXML.attachments.name = "SimpleDiagram : " + messageTitle
			msgXML.post["extended-body"] = extendedMessageBody
			msgXML.attachments.file.file = imageUploadID
				
			//add notifications if enabled and people selected
			
			if (basecampModel.enableNotifications && basecampModel.selectedPeopleAC.length>0)
			{
				for each (var personVO:PersonVO in basecampModel.selectedPeopleAC)
				{
					var notifyXML:XML = <notify />
					notifyXML.appendChild(personVO.id)
					msgXML.insertChildAfter(msgXML.post, notifyXML)
				}
			}
			
				
			service.request = msgXML
			service.method="POST"				
			return service.send()

		}
	
		private function addAuthHeader(service:HTTPService):void
		{
			
			var username:String = basecampModel.basecampLogin
			var password:String = basecampModel.basecampPassword
			
			Logger.debug("username: " + username,this)
			
			Logger.debug("password: " + password,this)
				
			//add the header to request
			var enc:Base64Encoder = new Base64Encoder();
			enc.encode(username + ":" + password);
			service.headers["Authorization"] = "Basic " + enc.toString();
		}

	
		
	}
}