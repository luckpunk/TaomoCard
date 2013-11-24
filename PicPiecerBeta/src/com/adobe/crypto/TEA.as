package com.adobe.crypto
{
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
	public class TEA extends Sprite
	{
		public function TEA()
		{
			//var key:Array = [0xd9,0xa5,0xe4,0xf6,0xa8,0xe3,0x94,0x8c,0xc3,0xd7,0x4b,0x9d,0x8d,0x9c,0xd3,0x7a];
			
			
			
		}
		
		
		/**
		 * Encrypts a byteArray with the specified key.
		 */
		public static function __encrypt(src:ByteArray, key:Array):Array {
			var v:Array = [];
			src.position = 0;
			
			var encrypt_len:int = Math.floor(src.length/8)*8
			var i:int = 0;
			var left_len:int = src.length - encrypt_len;
			
			for (i = 0;i < encrypt_len;i++){
				var test:int;
				test = src.readUnsignedByte();
				v.push(test)
				
			}
			//src.position = 0;
			var dst_ary:Array = _encrypt(v,key);
			
			for (i = 0;i< left_len;i++ ){
				dst_ary.push(src.readUnsignedByte());
			}
			

			return dst_ary;
		}
		
		
		
		/**
		 * Encrypts a string with the specified key.
		 */
		public static function encrypt(src:String, key:Array):Array {
			var v:Array = charsToLongs(strToChars(src));					
			var k:Array = charsToLongs(key);
			
			
			var n:Number = v.length;
			if (n == 0) return [];
			if (n == 1) v[n++] = 0;
			
			var a:uint = k[0], b:uint = k[1], c:uint = k[2] , d:uint = k[3],delta:int = 0x9E3779B9;			
			for(var i:int = 0 ; i < n-1 ;i ++){			
				
				var z:uint = v[n-1], y:uint = v[0];
				var sum:int = 0;
				for(var j:int = 0;j < 32;j++){
					sum += delta;
					y += ((z << 4) + a) ^ (z + sum) ^ ((z >>> 5) + b);
					z += ((y << 4) + c) ^ (y + sum) ^ ((y >>> 5) + d);
				}				
				v[0] = y;
				v[1] = z;
			}
			return v;
		}
		
		
		
		/**
		 * Encrypts an array with the specified key.
		 */
		public static function _encrypt(src:Array, key:Array):Array {
			
			
			
			var v:Array = charsToLongs(src);	
			var k:Array = charsToLongs(key);
			var n:int = src.length;
			if (n%8 != 0) return [];
			
			var a:uint = k[0], b:uint = k[1], c:uint = k[2] , d:uint = k[3],delta:int = 0x9E3779B9;
			//trace(k[0],k[1],k[2],k[3]);
			var iv:int = 0;
			for(var i:int = 0 ; i < n ;i +=8){
				
				var y:uint = v[iv], z:uint = v[iv+1];
				var sum:int = 0;
				var j:int;
				for(j = 0;j < 32;j++){
					sum += delta;
					y += ((z << 4) + a) ^ (z + sum) ^ ((z >>> 5) + b);
					z += ((y << 4) + c) ^ (y + sum) ^ ((y >>> 5) + d);
				}				
				v[iv] = [y];
				v[iv+1] = [z];
				iv+=2;
			}
			src = longsToChars(v);
			var t:int = 0;
			while(t<src.length)
			{
				//trace(src[t]);		
				t++;
			}
			
			return src;
		}
		
		
		
		/**
		 * Decrypts a string with the specified key.
		 */
		public static function decrypt(src:String, key:String):String {
			var v:Array = charsToLongs(hexToChars(src));
			var k:Array = charsToLongs(strToChars(key));
			var n:Number = v.length;
			if (n == 0) return "";
			var z:Number = v[n-1], y:Number = v[0], delta:Number = 0x9E3779B9;
			var mx:Number, e:Number, q:Number = Math.floor(6 + 52/n), sum:Number = q*delta;
			while (sum != 0) {
				e = sum>>>2 & 3;
				for(var p:Number = n-1; p > 0; p--){
					z = v[p-1];
					mx = (z>>>5^y<<2)+(y>>>3^z<<4)^(sum^y)+(k[p&3^e]^z);
					y = v[p] -= mx;
				}
				z = v[n-1];
				mx = (z>>>5^y<<2)+(y>>>3^z<<4)^(sum^y)+(k[p&3^e]^z);
				y = v[0] -= mx;
				sum -= delta;
			}
			return charsToStr(longsToChars(v));
		}
		
		/**
		 * Private methods.
		 */
		private static function charsToLongs(chars:Array):Array {
			var temp:Array = new Array(Math.ceil(chars.length/4));
			for (var i:Number = 0; i<temp.length; i++) {
				temp[i] = chars[i*4] + (chars[i*4+1]<<8) + (chars[i*4+2]<<16) + (chars[i*4+3]<<24);
			}
			return temp;
		}
		private static function longsToChars(longs:Array):Array {
			var codes:Array = new Array();
			for (var i:Number = 0; i<longs.length; i++) {
				codes.push(longs[i] & 0xFF, longs[i]>>>8 & 0xFF, longs[i]>>>16 & 0xFF, longs[i]>>>24 & 0xFF);
			}
			return codes;
		}
		private static function charsToHex(chars:Array):String {
			var result:String = new String("");
			var hexes:Array = new Array("0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f");
			for (var i:Number = 0; i<chars.length; i++) {
				result += hexes[chars[i] >> 4] + hexes[chars[i] & 0xf];
			}
			return result;
		}
		private static function hexToChars(hex:String):Array {
			var codes:Array = new Array();
			for (var i:Number = (hex.substr(0, 2) == "0x") ? 2 : 0; i<hex.length; i+=2) {
				codes.push(parseInt(hex.substr(i, 2), 16));
			}
			return codes;
		}
		private static function charsToStr(chars:Array):String {
			var result:String = new String("");
			for (var i:Number = 0; i<chars.length; i++) {
				result += String.fromCharCode(chars[i]);
				
			}
			return result;
		}
		private static function strToChars(str:String):Array {
			var codes:Array = new Array();
			for (var i:Number = 0; i<str.length; i++) {
				codes.push(str.charCodeAt(i));
				
			}
			return codes;
		}
		
	}
}