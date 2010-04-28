package com.roguedevelopment.objecthandles
{
	import com.roguedevelopment.objecthandles.constraints.MaintainProportionConstraint;
	
	import flash.geom.Point;
	
	import mx.core.ClassFactory;
	
	public class HandleDefinitions
	{
		
		public static const MAINTAIN_PROPORTION_DEFINITION:Array = [
									 new HandleDescription( HandleRoles.RESIZE_UP + HandleRoles.RESIZE_LEFT, 
																				new Point(0,0) ,
																				new Point(0,0), null, new ClassFactory(MaintainProportionConstraint) ),  
								
								
									 new HandleDescription( HandleRoles.RESIZE_UP + HandleRoles.RESIZE_RIGHT,
																				new Point(100,0) ,
																				new Point(0,0), null, new ClassFactory(MaintainProportionConstraint) ),
																
									 new HandleDescription( HandleRoles.RESIZE_DOWN + HandleRoles.RESIZE_RIGHT,
																				new Point(100,100) , 
																				new Point(0,0), null, new ClassFactory(MaintainProportionConstraint) ),  
																		
									 new HandleDescription( HandleRoles.RESIZE_DOWN + HandleRoles.RESIZE_LEFT,
																				new Point(0,100) ,
																				new Point(0,0), null, new ClassFactory(MaintainProportionConstraint) ),
																	
									 new HandleDescription( HandleRoles.ROTATE,
																				new Point(100,50) , 
																				new Point(20,0) ) 		
						];
		
		
		public static const DEFAULT_DEFINITION:Array = [
									 new HandleDescription( HandleRoles.RESIZE_UP + HandleRoles.RESIZE_LEFT, 
																				new Point(0,0) ,
																				new Point(0,0) ),  
								
									 new HandleDescription( HandleRoles.RESIZE_UP ,
																				new Point(50,0) , 
																				new Point(0,0) ),  
								
									 new HandleDescription( HandleRoles.RESIZE_UP + HandleRoles.RESIZE_RIGHT,
																				new Point(100,0) ,
																				new Point(0,0) ),  
								
									 new HandleDescription( HandleRoles.RESIZE_RIGHT,
																				new Point(100,50) , 
																				new Point(0,0) ),  
								
									 new HandleDescription( HandleRoles.RESIZE_DOWN + HandleRoles.RESIZE_RIGHT,
																				new Point(100,100) , 
																				new Point(0,0) ),  
									
									 new HandleDescription( HandleRoles.RESIZE_DOWN ,
																				new Point(50,100) ,
																				new Point(0,0) ),  
									
									 new HandleDescription( HandleRoles.RESIZE_DOWN + HandleRoles.RESIZE_LEFT,
																				new Point(0,100) ,
																				new Point(0,0) ),  
								
									 new HandleDescription( HandleRoles.RESIZE_LEFT,
																				new Point(0,50) ,
																				new Point(0,0) ),  
									
									 new HandleDescription( HandleRoles.ROTATE,
																				new Point(100,50) , 
																				new Point(20,0) ) 		
						];
						
				public static const NO_ROTATE_DEFINITION:Array = [
									 new HandleDescription( HandleRoles.RESIZE_UP + HandleRoles.RESIZE_LEFT, 
																				new Point(0,0) ,
																				new Point(0,0) ),  
								
									 new HandleDescription( HandleRoles.RESIZE_UP ,
																				new Point(50,0) , 
																				new Point(0,0) ),  
								
									 new HandleDescription( HandleRoles.RESIZE_UP + HandleRoles.RESIZE_RIGHT,
																				new Point(100,0) ,
																				new Point(0,0) ),  
								
									 new HandleDescription( HandleRoles.RESIZE_RIGHT,
																				new Point(100,50) , 
																				new Point(0,0) ),  
								
									 new HandleDescription( HandleRoles.RESIZE_DOWN + HandleRoles.RESIZE_RIGHT,
																				new Point(100,100) , 
																				new Point(0,0) ),  
									
									 new HandleDescription( HandleRoles.RESIZE_DOWN ,
																				new Point(50,100) ,
																				new Point(0,0) ),  
									
									 new HandleDescription( HandleRoles.RESIZE_DOWN + HandleRoles.RESIZE_LEFT,
																				new Point(0,100) ,
																				new Point(0,0) ),  
								
									 new HandleDescription( HandleRoles.RESIZE_LEFT,
																				new Point(0,50) ,
																				new Point(0,0) )  
									
									 
						];
		public static const DEFAULT_PLUS_MOVE_DEFINITION:Array = [
									new HandleDescription( HandleRoles.MOVE, 
																				new Point(50,50) ,
																				new Point(0,0) ),
																				  
									 new HandleDescription( HandleRoles.RESIZE_UP + HandleRoles.RESIZE_LEFT, 
																				new Point(0,0) ,
																				new Point(0,0) ),  
								
									 new HandleDescription( HandleRoles.RESIZE_UP ,
																				new Point(50,0) , 
																				new Point(0,0) ),  
								
									 new HandleDescription( HandleRoles.RESIZE_UP + HandleRoles.RESIZE_RIGHT,
																				new Point(100,0) ,
																				new Point(0,0) ),  
								
									 new HandleDescription( HandleRoles.RESIZE_RIGHT,
																				new Point(100,50) , 
																				new Point(0,0) ),  
								
									 new HandleDescription( HandleRoles.RESIZE_DOWN + HandleRoles.RESIZE_RIGHT,
																				new Point(100,100) , 
																				new Point(0,0) ),  
									
									 new HandleDescription( HandleRoles.RESIZE_DOWN ,
																				new Point(50,100) ,
																				new Point(0,0) ),  
									
									 new HandleDescription( HandleRoles.RESIZE_DOWN + HandleRoles.RESIZE_LEFT,
																				new Point(0,100) ,
																				new Point(0,0) ),  
								
									 new HandleDescription( HandleRoles.RESIZE_LEFT,
																				new Point(0,50) ,
																				new Point(0,0) ),  
									
									 new HandleDescription( HandleRoles.ROTATE,
																				new Point(100,50) , 
																				new Point(20,0) ) 		
						];
	}
}