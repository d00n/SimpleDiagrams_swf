


import com.simplediagrams.events.ApplicationEvent
import com.simplediagrams.util.Logger;
import flash.events.KeyboardEvent	
import org.swizframework.Swiz;


//TODO: Implement updated when AIR 2.0 released
//private var updater:ApplicationUpdaterUI 


protected function onKeyDown(event:KeyboardEvent):void
{
	Logger.debug("app level key down", this)
}


protected function onPreInit():void
{	
	
	Logger.info("#SIMPLEDIAGRAMS: PRE-INITIALIZED")
	Logger.info("==================================================") 
	
	/*
	updater = new ApplicationUpdaterUI();
	updater.configurationFile = new File("app:/config/updaterConfig.xml");
	updater.addEventListener(UpdateEvent.INITIALIZED, updaterInitialized);
	updater.initialize();  			
	*/
}

/*
private function updaterInitialized(event:UpdateEvent):void
{
updater.checkNow();
}
protected function onUpdaterInit(event:UpdateEvent):void
{
isFirstRun = event.target.isFirstRun
} 
*/



protected function onAppComplete():void
{
	Swiz.dispatchEvent(new ApplicationEvent(ApplicationEvent.INIT_APP, true))
}


//TODO: implement this when Swiz remote calls are implemented
protected function genericFault(fe:FaultEvent):void
{
	Logger.error("#FAULT EVENT: " + fe)
}


