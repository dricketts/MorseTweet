package  {
	
	public class LightPulse extends Object
	{
		public var lightState:Boolean;
		public var pulseDuration:uint;
		
		public function LightPulse(lightState:Boolean, pulseDuration:uint)
		{
			this.lightState = lightState;
			this.pulseDuration = pulseDuration;
		}
		
		public function toString():String
		{
			return "(" + this.lightState + ", " + this.pulseDuration + ")";
		}
	}
	
}
