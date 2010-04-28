package com.simplediagrams.util
{
	
	import com.simplediagrams.model.ApplicationModel;
	
	import flash.events.IOErrorEvent;
//	import flash.filesystem.*;
	import flash.net.XMLSocket;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.logging.LogEventLevel;
	
	import org.spicefactory.lib.reflect.ClassInfo;
	import org.swizframework.Swiz;
	
	
	public class Logger	
	{
						
		public static var reportErrorsToCMS:Boolean = true
		
		public static var enabled : Boolean = true;
		public static var myLogger : ILogger
		private static var socket : XMLSocket;
//		public static var logFile:File		
//		public static var logFileStream:FileStream
		public static var logToFile:Boolean = true;
		
		

		public static function debug(o:Object, target:Object=null):void
		{
			_send(LogEventLevel.DEBUG, o, target);
		}

		public static function info(o:Object, target:Object=null):void
		{
			_send(LogEventLevel.INFO, o, target);
		}
		
		public static function warn(o:Object, target:Object=null):void
		{
			_send(LogEventLevel.WARN, o, target);
		}
		
		public static function error(o:Object, target:Object=null):void
		{
			_send(LogEventLevel.ERROR, o, target);
		}

		public static function fatal(o:Object, target:Object=null):void
		{
			_send(LogEventLevel.FATAL, o, target);
		}
		
		public static function all(o:Object, target:Object=null):void
		{
			_send(LogEventLevel.ALL, o, target);
		}

		private static function onSocketError(err:IOErrorEvent):void
		{
				//do nothing.
		}
			
		private static function _send(lvl:Number, o:Object, target:Object):void
		{
			
			if (target!=null)
			{
				var ci:ClassInfo = ClassInfo.forInstance(target);
				var targetName:String = ci.simpleName
			}
			else
			{
				targetName=""
			}
			
			if (myLogger == null)
			{
				myLogger = Log.getLogger("com.simplediagrams") 
			}
						
			
			var type:String
			switch(lvl)
            {
            	case LogEventLevel.DEBUG:
					type = "DEBUG:"
                	if (Log.isDebug()) {
                    	myLogger.debug(targetName + " : " + o.toString()) 
                    }
                    break;
				case LogEventLevel.INFO:
					type = "INFO:"
					if (Log.isInfo()) {
						myLogger.info(targetName + " : " +o.toString()); 
					}
					break;
				case LogEventLevel.WARN:
					type = "WARN:"
					if (Log.isWarn()) {
                        myLogger.warn(targetName + " : " + o.toString());
                    }
                    break;
                case LogEventLevel.ERROR:
					type = "ERROR:"
                    if (Log.isError()) {
                        myLogger.error(targetName + " : " + o.toString());
                    }
                    break;
                case LogEventLevel.FATAL:
					type = "FATAL:"
                    if (Log.isFatal()) {
                        myLogger.fatal(targetName + " : " + o.toString());
                    }
                    break;
				case LogEventLevel.ALL:
					type = "ALL:"
					myLogger.log(lvl, targetName + " : " +  o.toString());
					break;
            }
            
           
            //log to file 
            try
            {
//				if (logFile==null)
//				{
//					var logFileDir:File = File.applicationStorageDirectory.resolvePath(ApplicationModel.logFileDir)
//	           		logFile = logFileDir.resolvePath(ApplicationModel.logFileName)
//	           		logFileStream = new FileStream()
//	   			}
//	   			
//	   			if (logToFile)
//	   			{					
//					logFileStream.open(logFile, FileMode.APPEND)
//	   				logFileStream.writeUTFBytes( File.lineEnding + type + o)
//	   				logFileStream.close()
//	   			}
            }
	   		catch(err:Error)
	   		{
	   			trace("ERROR in logging to file! err: " + err)
	   		}
				
		}
	

	}


}
