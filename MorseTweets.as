package 
{ 

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.events.MouseEvent;
	
	// This is the "main" class for this app.
	// Right now it only contains a text field for a username
	// and a button which will start the stream of tweets.
    public class MorseTweets extends Sprite
    {
		
		// The text field for the username input.
		private var usernameField:TextField;
		// The button for starting the stream.
		private var startStreamButton:Sprite;
		// The incoming tweet stream for the user.
		private var tweetStream:TweetStream;
		
		// Creates the text field and start stream button.
		// Also initiates the tweet stream.
		public function MorseTweets() {
			usernameField = createInputTextField("Username", 10, 10, 30, 200);
			createGoButton(100,100);
			tweetStream = new TweetStream();
		}
		
		// Creates an input text field.
		private function createInputTextField(label:String, x:int, y:int, height:int, width:int):TextField {
			var theTextField:TextField = new TextField();
			theTextField.type = TextFieldType.INPUT;
			theTextField.border = true;
			theTextField.x = x;
			theTextField.y = y;
			theTextField.height = height;
			theTextField.width = width;
			theTextField.multiline = true;
			theTextField.wordWrap = true;
			addChild(theTextField);
			return theTextField;
		}
		
		// Creates the start stream button.
		private function createGoButton(x:int, y:int) {
			var textLabel:TextField = new TextField();
			startStreamButton = new Sprite();
			startStreamButton.x = x;
			startStreamButton.y = y;
            startStreamButton.graphics.clear();
            startStreamButton.graphics.beginFill(0xD4D4D4); // grey color
            startStreamButton.graphics.drawRoundRect(0, 0, 80, 25, 10, 10); // x, y, width, height, ellipseW, ellipseH
            startStreamButton.graphics.endFill();
            textLabel.text = "Start Stream";
            textLabel.x = 3;
            textLabel.y = 2;
            textLabel.selectable = false;
			addChild(startStreamButton);
            startStreamButton.addChild(textLabel);
			startStreamButton.addEventListener(MouseEvent.MOUSE_DOWN, startStreamListener);
		}
		
		// Called when the user presses the start stream button.
		private function startStreamListener(event:MouseEvent) {
			var following:Vector.<int> = Util.getFollowing(usernameField.text);
			for (var id in following) {
				tweetStream.addFollowing(id);
			}
			tweetStream.startStream();
		}
		
    } 
}