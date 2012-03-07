package
{
	
	import flash.net.URLRequest;
  	import flash.net.URLRequestHeader;
  	import flash.net.URLRequestMethod;
  	import flash.net.URLStream;
	import flash.events.IOErrorEvent;
  	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;
	import com.adobe.serialization.json.*;
	
	public class TweetStream
	{
		// The url of the proxy server that gets past the cross-domain issue.
		private const url = "http://raylewis.ucsd.edu/proxy.php?sd=stream&path=1/statuses/filter.json";
		
		// contains the tweets that have not yet been
		// consumed by getNextTweet()
		private var tweetQueue:Vector.<Tweet>;
		// The ids of followers
		private var following:Vector.<int>;
		// List of keywords to track.
		private var tracking:Vector.<String>;
		// The raw url stream from twitter
		private var stream:URLStream;
		// The list of listeners to this stream
		private var listeners:Vector.<Function>;
		
		public function TweetStream() {
			tweetQueue = new Vector.<Tweet>();
			following = new Vector.<int>();
			listeners = new Vector.<Function>();
			tracking = new Vector.<String>();
		}
		
		public function addStreamListener(callback:Function) {
			trace("Callback added",callback);
			listeners.push(callback);
		}
		
		// Adds another user to the list of following.
		public function addFollowing(id:int) {
			following.push(id);
		}
		
		// Adds a keyword to track
		public function addTracking(keyword:String) {
			tracking.push(keyword);
		}
		
		// Starts the stream using the given filter parameters.
		// Tweets can be consumed by calling getNextTweet();
		public function startStream() {
			// Close the old stream if it exists.
			if (stream != null) {
				stream.close();
			}
			
			amountRead = 0;
        	streamBuffer = "";
        	var request:URLRequest = createStreamRequest(url);
        	stream = new URLStream();
        	stream.addEventListener(IOErrorEvent.IO_ERROR, errorReceived);
        	stream.addEventListener(ProgressEvent.PROGRESS, dataReceived);
        	stream.load(request);
		}
		
		private function createStreamRequest(url:String):URLRequest {
      		var request:URLRequest = new URLRequest(url);
      		request.method = URLRequestMethod.POST;
			
			var headers:Array = new Array();
			// TODO add tracking keywords and followers.
			
			request.requestHeaders = 
      		request.data = 0;
      		return request;
    	}
		
		// Called when a new tweet is created and should be
		// broadcasted to the listeners.
		private function newTweet(tweet:Tweet) {
			listeners.forEach(function(f:Function,i:int,v:Vector.<Function>) {f(tweet);});
		}
		
		// a simple helper that will base-64 encode a string
    	private function b64encode(s:String):String {
			var toencode = new ByteArray();
			toencode.writeMultiByte(s, "utf-8");
      		return Base64.encode(toencode);
    	}
		
		private function encodeStringForTransport(s:String):String {
      		return s.split("%").join("%25").split("\\").join("%5c").split("\"").join("%22").split("&").join("%26");
    	}
		
		// parse the incoming data stream -- this will call out to "streamEvent"
    	// in javascript with the JSON
    	private var amountRead:int = 0;
    	private var isReading:Boolean = false;
    	private var streamBuffer:String = "";
    	private function dataReceived(pe:ProgressEvent):void {
      		var toRead:Number = pe.bytesLoaded - amountRead;
      		var buffer:String = stream.readUTFBytes(toRead);
      		amountRead = pe.bytesLoaded;
			

      		// attempt to restart the stream
      		var parts:Array;

      		// pump the JSON pieces through
      		if ((toRead > 0) && (amountRead > 0)) {
        		streamBuffer += buffer;
        		parts = streamBuffer.split(/\r/);
        		var lastElement:String = parts.pop();
        		parts.forEach(function(s:String, i:int, a:Array):void {
					var json:Object = JSON.decode(s);
					var tweet:Tweet = new Tweet();
					tweet.setTweetText(json.text);
					newTweet(tweet);
        		});
        		streamBuffer = lastElement;
      		}
   		}

    	// call out to javascript that there was an error in the stream
    	private function errorReceived(io:IOErrorEvent):void {
			trace(io);
    	}
	}
	
}

