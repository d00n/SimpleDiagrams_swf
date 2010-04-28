package com.simplediagrams.business
{
	
	import com.simplediagrams.model.UserModel;
	import com.simplediagrams.util.Logger
	
	import mx.rpc.AsyncToken;
	import mx.rpc.http.HTTPService;

	public class SimpleDiagramsDelegate 
	{	
		
		//[Autowire(bean="simpleDiagramService")]
		public var _service:HTTPService;
			
		private var _baseURL:String = "http://www.simplediagrams.com/"
				
		public function SimpleDiagramsDelegate() 
		{
			_service = new HTTPService()
		}
				
		
		public function login(userModel:UserModel, key:String):AsyncToken
		{
			Logger.debug("username: " + userModel.username, this)
			
			
			_service.disconnect()
			_service.url = _baseURL + "user_sessions/client_login" 
			var requestObj:Object = {}
			requestObj.username = userModel.username
			requestObj.password = userModel.password
			//requestObj.key = key
			_service.method = "POST"
			_service.resultFormat = "e4x" 
			_service.request = requestObj
		
			return _service.send()
		}
		
		public function logout():AsyncToken
		{
			_service.url = _baseURL + "user_sessions/client_logout"
			_service.method = "GET"
			_service.contentType = "application/x-www-form-urlencoded"
			return _service.send()
		}
		
		public function getLibraryList():AsyncToken
		{
			_service.disconnect()
			_service.url = _baseURL + "users/libraries.xml"
			_service.method = "GET"
			_service.resultFormat = "e4x" 
			_service.contentType = "application/x-www-form-urlencoded"
			_service.request = {}
			return _service.send()
				
		}
		
		
	}
}