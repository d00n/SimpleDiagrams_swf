package com.adobe.example.signature
{
	
	import com.simplediagrams.util.Logger;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
//	import flash.filesystem.*;
	import flash.security.IURIDereferencer;
	import flash.security.ReferencesValidationSetting;
	import flash.security.RevocationCheckSettings;
	import flash.security.SignatureStatus;
	import flash.security.XMLSignatureValidator;
	import flash.utils.ByteArray;
	
	import mx.utils.Base64Decoder;
	import mx.utils.Base64Encoder;
	import mx.utils.SHA256;
	
	public class SignatureValidator extends EventDispatcher
	{
		
//		public var sigFile:File
		[Bindable] public var xmlDoc:XML
		public var xmlSig:XML
		public const signatureNS:Namespace = new Namespace("http://www.w3.org/2000/09/xmldsig#");
		
		[Bindable]
		public var statusText:String = '';
		
		[Bindable]
		public var signatureText:String = '';
		
		public function SignatureValidator()
		{
		}
		
		
//		public function loadFile(sigFile:File):void
//		{
//			Logger.debug("loadFile() sigFile: " + sigFile.nativePath, this)
//			this.sigFile = sigFile
//			var sigFileStream:FileStream = new FileStream()
//			sigFileStream.open(sigFile, FileMode.READ)
//			var fileContents:String = sigFileStream.readUTFBytes(sigFileStream.bytesAvailable)
//			xmlDoc = new XML( fileContents )
//			var signatureList:XMLList = xmlDoc..signatureNS::Signature
//			if( signatureList.length() > 0 )
//			{
//				xmlSig = XML( signatureList[signatureList.length()-1] )
//			} 
//			else 
//			{
//				Logger.error( sigFile.name + " does not contain a recognized XML signature." )
//			}		
//		}
//		
//		
//		public function validate():void
//		{			
//			Logger.debug("validate()", this)
//			var verifier:XMLSignatureValidator = new XMLSignatureValidator()
//			verifier.addEventListener(Event.COMPLETE, signatureVerificationComplete)
//			verifier.addEventListener(ErrorEvent.ERROR, signatureVerificationError)
//			
//			try
//			{
//				//Get the certificate from the signature
//				var decoder:Base64Decoder = new Base64Decoder()
//				decoder.decode(xmlSig..signatureNS::X509Certificate)
//				var certificate:ByteArray = decoder.toByteArray()
//				
//				//Set the validation options
//				//In most cases you do NOT want to trust the signing cert automatically
//				verifier.useSystemTrustStore = true
//				verifier.addCertificate(certificate, true)
//				verifier.referencesValidationSetting = ReferencesValidationSetting.VALID_OR_UNKNOWN_IDENTITY
//				verifier.revocationCheckSetting = RevocationCheckSettings.BEST_EFFORT
//				
//				//Setup the dereferencer
//				var dereferencer:IURIDereferencer = new LimitedSignatureDereferencer(xmlDoc)
//				verifier.uriDereferencer = dereferencer
//				
//				//Validate the signature
//				verifier.verify(xmlSig)
//				
//			}
//			catch (e:Error)
//			{				
//				Logger.debug( "Verification error.\n" + e )
//				throw new Error("Verification error")
//			}
//		}
//		
//		protected function signatureVerificationComplete(event:Event):void
//		{
//			Logger.debug("signatureVerificationComplete()", this)
//			var validator:XMLSignatureValidator = event.target as XMLSignatureValidator
//			
//			//Report the verification results
//			/*
//			Logger.debug("Signature status: " + validator.validityStatus)
//			Logger.debug("  Digest status: " + validator.digestStatus )
//			Logger.debug("  Identity status: " + validator.identityStatus )
//			Logger.debug("  Reference status: " + validator.referencesStatus )
//			*/
//			//Display certificate information
//			if( validator.identityStatus == SignatureStatus.VALID )
//			{
//				//Logger.debug("\nSigning certificate information:\n")
//				//Logger.debug("  Common name field: " + validator.signerCN )
//				//Logger.debug("  Distinguished name field: " + validator.signerDN )
//				//Logger.debug("  Extended key usage OIDs: " + formatArray(validator.signerExtendedKeyUsages) )
//				//Logger.debug("  Trust settings: " + formatArray(validator.signerTrustSettings) )
//			} 
//			else 
//			{
//				Logger.debug("\nSigning certificate information only available for valid certificates.\n")
//			}
//			
//			//Verify the referenced files, but only if signature is valid
//			if( validator.referencesStatus == SignatureStatus.VALID )
//			{
//				var manifest:XMLList = xmlSig.signatureNS::Object.signatureNS::Manifest
//				if( manifest.length() > 0 )
//				{
//					if (verifyManifest( manifest ))
//					{
//						dispatchEvent(new Event("VALID"))
//					}
//					else
//					{
//						dispatchEvent(new Event("INVALID"))
//					}
//				}
//			} 
//			else 
//			{
//				Logger.debug("\nManifest only validated when signature references are valid.\n")
//			}
//		}
//		
//		protected function signatureVerificationError(event:ErrorEvent):void
//		{
//			Logger.debug("Verification error.\n" + event.text)		
//		}
//		
//		protected function verifyManifest( manifest:XMLList ):Boolean
//		{
//			Logger.debug("verifyManifest()", this)
//			var result:Boolean = true
//			var message:String = ''
//			var nameSpace:Namespace = manifest.namespace()
//			
//			if( manifest.nameSpace::Reference.length() <= 0 )
//			{
//				result = false
//				message = "Nothing to validate."
//			}
//			
//			for each (var reference:XML in manifest.nameSpace::Reference)
//			{
//				var file:File = sigFile.parent.parent.resolvePath(reference.@URI)
//				//Logger.debug("Looking for file : "+ file.nativePath, this)
//				if (file.exists == false) 
//				{
//					Logger.debug("Couldn't find file " + file.nativePath + " so this must be invalid.", this)
//					return false					
//				}
//				var stream:FileStream = new FileStream()
//				stream.open(file, FileMode.READ)
//				var fileData:ByteArray = new ByteArray()
//				stream.readBytes( fileData, 0, stream.bytesAvailable )
//				
//				var digestHexString:String = SHA256.computeDigest( fileData )
//				var digest:ByteArray = new ByteArray()
//				for( var c:int = 0; c < digestHexString.length; c += 2 )
//				{
//					var byteChar:String = digestHexString.charAt(c) + digestHexString.charAt(c+1)
//					digest.writeByte( parseInt( byteChar, 16 ))
//				}
//				digest.position = 0
//				
//				var base64Encoder:Base64Encoder = new Base64Encoder()
//				base64Encoder.insertNewLines = false
//				base64Encoder.encodeBytes( digest, 0, digest.bytesAvailable )
//				var digestBase64:String = base64Encoder.toString()
//				if( digestBase64 == reference.nameSpace::DigestValue )
//				{
//					result = result && true
//					message += "   " + reference.@URI + " verified.\n"
//				} 
//				else 
//				{
//					result = false
//					message += "    >>>>>" + reference.@URI + " has been modified!\n"
//					throw new Error("The file: " + reference.@URI + " has been modified")
//				}
//				base64Encoder.reset()
//			}
//			Logger.debug( "\nPackage files:\n" )
//			Logger.debug( message )
//			return result
//		}
		
		
		
		
		public function formatArray( array:Array ):String 
		{
			if( array.length > 0 )
			{
				var commaDelimitedList:String = ""
				for( var i:int; i < array.length - 1; i++ )
				{
					commaDelimitedList += array[i].toString() + ", "
				}
				commaDelimitedList += array[array.length - 1].toString()
				return commaDelimitedList
			} 
			else
			{
				return ""
			}
		}
		
	

	}
}

