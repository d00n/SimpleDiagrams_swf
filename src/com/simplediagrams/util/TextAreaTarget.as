package com.simplediagrams.util
{
	import mx.controls.TextArea;
	import mx.core.mx_internal;
	import mx.logging.targets.LineFormattedTarget;
	
	use namespace mx_internal;
	
	public class TextAreaTarget extends LineFormattedTarget
	{
		private var textArea:TextArea;
		
		public function TextAreaTarget(textArea:TextArea)
		{
			this.textArea = textArea;
		}
		
		mx_internal override function internalLog(message:String):void
	    {
			write(message);
	    }		
		
		private function write(msg:String):void
		{		
			if(textArea == null)
			{
				return;
			}
			
			textArea.text += msg + "\n";
		}			
		
		public function clear():void
		{
			if(textArea == null)
			{
				return;
			}
			
			textArea.text = "";	
		}
		
	}
}