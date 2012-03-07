package 
{

	public class MorseWebcamLight
	{
		private static var DIT:String = "1";
		private static var DAH:String = "111";
		private static var INTRA_CHAR_GAP = "0";
		private static var INTER_CHAR_GAP = "000";
		private static var INTER_WORD_GAP = "0000000";
		
		private static var MORSE_CODE:Object = 
			{
				"A": [DIT, DAH],
				"B": [DAH, DIT, DIT, DIT],
				"C": [DAH, DIT, DAH, DIT],
				"D": [DAH, DIT, DIT],
				"E": [DIT],
				"F": [DIT, DIT, DAH, DIT],
				"G": [DAH, DAH, DIT],
				"H": [DIT, DIT, DIT, DIT],
				"I": [DIT, DIT],
				"J": [DIT, DAH, DAH, DAH],
				"K": [DAH, DIT ,DAH],
				"L": [DIT, DAH, DIT , DIT],
				"M": [DAH, DAH],
				"N": [DAH, DIT],
				"O": [DAH, DAH, DAH],
				"P": [DIT, DAH, DAH, DIT],
				"Q": [DAH, DAH, DIT, DAH],
				"R": [DIT, DAH, DIT],
				"S": [DIT, DIT, DIT],
				"T": [DAH],
				"U": [DIT, DIT, DAH],
				"V": [DIT, DIT, DIT, DAH],
				"W": [DIT, DAH, DAH],
				"X": [DAH, DIT, DIT, DAH],
				"Y": [DAH, DIT, DAH, DAH],
				"Z": [DAH, DAH, DIT, DIT],
				"0": [DAH, DAH, DAH, DAH, DAH],
				"1": [DIT, DAH, DAH, DAH, DAH],
				"2": [DIT, DIT, DAH, DAH, DAH],
				"3": [DIT, DIT, DIT, DAH, DAH],
				"4": [DIT, DIT, DIT, DIT, DAH],
				"5": [DIT, DIT, DIT, DIT, DIT],
				"6": [DAH, DIT, DIT, DIT, DIT],
				"7": [DAH, DAH, DIT, DIT, DIT],
				"8": [DAH, DAH, DAH, DIT, DIT],
				"9": [DAH, DAH, DAH, DAH, DIT],
				".": [DIT, DAH, DIT, DAH, DIT, DAH],
				",": [DAH, DAH, DIT, DIT, DIT, DAH, DAH],
				"?": [DIT, DIT, DAH, DAH, DIT, DIT],
				"'": [DIT, DAH, DAH, DAH, DAH, DIT],
				"!": [DAH, DIT, DAH, DIT, DAH, DAH],
				"/": [DAH, DIT, DIT, DAH, DIT],
				"(": [DAH, DIT, DAH, DAH, DIT],
				")": [DAH, DIT, DAH, DAH, DIT, DAH],
				"&": [DIT, DAH, DIT, DIT, DIT],
				":": [DAH, DAH, DAH, DIT, DIT, DIT],
				";": [DAH, DIT, DAH, DIT, DAH, DIT],
				"=": [DAH, DIT, DIT, DIT, DAH],
				"+": [DIT, DAH, DIT, DAH, DIT],
				"-": [DAH, DIT, DIT, DIT, DIT, DAH],
				"_": [DIT, DIT, DAH, DAH, DIT, DAH],
				"\"": [DIT, DAH, DIT, DIT, DAH, DIT],
				"$": [DIT, DIT, DIT, DAH, DIT, DIT, DAH],
				"@": [DIT, DAH, DAH, DIT, DAH ,DIT]
			};
			
		private var camlight:WebcamLightswitch;
		private var unitLengthMilliseconds:uint = 200;

		public function MorseWebcamLight()
		{
			this.camlight = new WebcamLightswitch();
		}

		private function displayCharacter(char:String)
		{
			if (MORSE_CODE.hasOwnProperty(char))
			{
				camlight.scheduleLight(charToLightPulses(char));
			}
		}
		
		public function displayString(str:String)
		{
			str = str.toUpperCase();
			for (var i = 0; i < str.length; i++)
			{
				if (MORSE_CODE.hasOwnProperty(str.charAt(i)))
				{
					displayCharacter(str.charAt(i));
					if (i+1 < str.length && MORSE_CODE.hasOwnProperty(str.charAt(i+1))) // inter-character gap
						camlight.scheduleLight([new LightPulse(false, 3*this.unitLengthMilliseconds)]);
				}
				else if (str.charAt(i) == " " && (i == str.length-1 || str.charAt(i+1) != " ")) // inter-word gap
				{
					camlight.scheduleLight([new LightPulse(false, 7*this.unitLengthMilliseconds)]);
				}
			}
			camlight.scheduleLight([new LightPulse(false, 7*this.unitLengthMilliseconds)]); // force an inter-word gap when done
		}
		
		private function charToLightPulses(char:String):Array
		{
			var result:Array = new Array();

			if (MORSE_CODE.hasOwnProperty(char))
			{
				for (var i = 0; i < MORSE_CODE[char].length; i++)
				{
					if (i > 0) // intra-char gap
					{
						result.push(new LightPulse(false, this.unitLengthMilliseconds));
					}
					if (MORSE_CODE[char][i] == DIT)
					{
						result.push(new LightPulse(true, this.unitLengthMilliseconds));
					}
					else // DAH
					{
						result.push(new LightPulse(true, 3*this.unitLengthMilliseconds));
					}
				}
			}
			return result;
		}
	}

}

