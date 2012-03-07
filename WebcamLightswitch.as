package 
{

	import flash.display.Sprite;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.events.StatusEvent;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.utils.*;

	public class WebcamLightswitch extends Sprite
	{
		private var cam:Camera = null;
		private var vid:Video = null;
		private var lightOn:Boolean = false;
		
		private var lightSchedule:Array;
		private var pulseInProgress:Boolean = false;
		private var lastPulseStarted:uint;

		public function WebcamLightswitch()
		{
			this.lightSchedule = new Array();
			initWebcam();
		}
		
		private function initWebcam():void
		{
			this.vid = new Video(1,1);
			this.vid.x = -1;
			this.vid.y = -1;
			this.addChild(this.vid);
			
			this.cam = Camera.getCamera();
			if (!this.cam)
			{
				; // no camera exists
			}
			else if (this.cam.muted) // webcam access needs to be enabled
			{
				Security.showSettings(SecurityPanel.PRIVACY);
				this.cam.addEventListener(StatusEvent.STATUS, camStatusHandler)
			}
			else // success
			{
				this.cam.setMode(1,1,1);
			}
		}
		
		private function camStatusHandler(e:StatusEvent)
		{
			if (e.code == "Camera.Unmuted")
			{
				;
			}
			else if (e.code == "Camera.Muted")
			{
				;
			}
		}
		
		public function enableLight()
		{
			this.lastPulseStarted = (new Date()).getTime();
			this.vid.attachCamera(this.cam);
		}
		
		public function disableLight()
		{
			var enabledFor:uint = (new Date()).getTime() - this.lastPulseStarted;
			trace("enabled for " + enabledFor);
			this.vid.attachCamera(null);
		}
		
		public function setLight(lightState:Boolean)
		{
			if (lightState)
			{
				this.enableLight();
			}
			else
			{
				this.disableLight();
			}
			this.lightOn = lightState;
		}
		
		public function toggleLight()
		{
			if (this.lightOn)
				this.disableLight();
			else
				this.enableLight();
		}
		
		public function scheduleLight(schedule:Array)
		{
			// could do checking on the argument here
			this.lightSchedule = this.lightSchedule.concat(schedule);
			if (!this.pulseInProgress)
				runSchedule();
		}
		
		private function runSchedule():void
		{
			if (this.lightSchedule.length > 0)
			{
				var nextCommand:LightPulse = this.lightSchedule.shift();
				if (nextCommand.lightState) trace("light: " + nextCommand.lightState + " for " + nextCommand.pulseDuration + " ms");
				setLight(nextCommand.lightState);
				setTimeout(runSchedule, nextCommand.pulseDuration);
				this.pulseInProgress = true;
			}
			else
			{
				this.pulseInProgress = false;
			}
		}
	}
}
