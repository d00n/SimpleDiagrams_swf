package com.simplediagrams.business
{	
	import com.simplediagrams.business.migrations.*;
	import com.simplediagrams.util.Logger;
	
//	import flash.filesystem.File;
	import org.swizframework.Swiz;
	import mx.controls.Alert;
	
	[Bindable]
	public class MigrationManager
	{
		
		
		//IMPORTANT: This variable should always be set to contain the most recent version of the DB
		public var latestVersion:Number = 0
		
		//Current version of the target machine'
		public var currentDBVersion:Number 
	
		private var _migrationsArr:Array
		
//		private var _copyDBFile:File		
		public var dbCopyPath:String = "Application Data/simplediagram/db/"
		private var _copyFileName:String //will be assigned a name based on current datetime 
//		private var _currDBFile:File
		private var _db:DBManager
		
		public function MigrationManager()
		{
			loadMigrations()			
		}
		
		public function loadMigrations():void
		{
			
			//all migrations should be added here. This will
			//serve as an authoratative list of all migrations that
			//should be applied to a database from the original version
			//to the most current
			
			//IMPORTANT: THESE MUST BE ADDED TO THE ARRAY IN ORDER OF THEIR VERSION NUMBER 
			_migrationsArr = []
			
			//_migrationsArr.push(new AddTimestampsToProject())
			
			var count:int = _migrationsArr.length
			for (var i:int = 0;i<count;i++)
			{
				latestVersion = Math.max(latestVersion, _migrationsArr[i].version)
			}
			
		}
		
		public function get db():DBManager
		{
			if (_db==null)
			{
				_db = Swiz.getBean("dbManager") as DBManager
			}
			
			return _db
			
		}
		
		/** Return true if database's version is the most recent. */		
		public function get isDBCurrent():Boolean
		{			
			Logger.debug("Checking db to see if it needs updating...", this)
			
			
		
			
			//first check whether DB is valid
			currentDBVersion = db.getDBVersion()
			
			Logger.debug("currentDBVersion:" + currentDBVersion, this)
			Logger.debug("latestVersion:   " + latestVersion, this)
						
			return (currentDBVersion >= latestVersion)
			
		}		
		
		/** Migrates DB to most recent version, based on migrations described in this class */
		public function migrateDB():void
		{
//			
//			Logger.debug("\n****************\nMIGRATING DB\n****************\n", this)
//						
//			//copy DB for safety
//			_copyDBFile = File.userDirectory
//			_copyDBFile = _copyDBFile.resolvePath(this.dbCopyPath)
//						
//			Logger.debug("_copyDBFile.nativePath: " + _copyDBFile.nativePath, this)
//			
//			//create directory if it doesn't exist
//			if (_copyDBFile.exists==false)
//			{
//				_copyDBFile.createDirectory()
//			}
//			
//			//create copy file 
//			_copyFileName = "simplediagram_db_bkup_" + new Date().getTime() + ".sqlite"
//			_copyDBFile = _copyDBFile.resolvePath(_copyFileName)
//						
//			//copy existing db to copy file
//			_currDBFile = File.applicationDirectory
//			_currDBFile = _currDBFile.resolvePath(_db.dbLocation)
//			Logger.debug("_currDBFile.nativePath: " + _currDBFile.nativePath, this)
//			
//			_currDBFile.copyTo(_copyDBFile)
//						
//			var success:Boolean = runMigrations()
//			
//			Logger.debug("migration complete. success: " + success, this)
//			
//			if (success)
//			{								
//				//delete copy
//				_copyDBFile.deleteFile()
//			}
//			else
//			{				
//				var errorMsg:String = "Couldn't update existing database to new version. Your existing database was copied to " +
//										 _copyDBFile.nativePath +". Please close this application and try installing again. If unsuccessful, " + 
//										 		"please contact SimpleDiagram customer support."
//										 
//				Alert.show(errorMsg, "Database update error")
//				
//			}
		}
		
		
		private function runMigrations():Boolean
		{
			Logger.debug("Checking DB to see if it needs updating...", this)
									
			currentDBVersion = db.getDBVersion()
						
			if (currentDBVersion < latestVersion)
			{
				//Perform all migrations with UTC timestamp (version) greater than currentDBVersion
				var count:int = _migrationsArr.length
				for (var i:uint=0;i<count;i++)
				{
					var migration:IMigration = _migrationsArr[i]
					
					if (migration.version > currentDBVersion)
					{
						Logger.debug("Migrating database. Performing following changes : " + migration.description)
						try
						{
							migration.migrate(db)
						}
						catch(err:Error)
						{
							//This is bad	
							Logger.error("Migration " + migration.version + " failed. Error:" + err)
							return false
						}
					}
				}
				
			}
			return true			
			
		}
		

		

	}
}