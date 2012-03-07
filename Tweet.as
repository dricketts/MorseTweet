package
{
	// Represents a Tweet.
	public class Tweet {
		
		private var user:String;
		private var userID:int;
		private var t:String;
		
		// Returns the user name who sent the tweet.
		public function getUser():String {
			return user;
		}
		
		// Returns the id of the user who sent the tweet.
		public function getUserID():int {
			return userID;
		}
		
		// Returns the text of the tweet.
		public function getTweetText():String {
			return t;
		}
		
		// Sets the user name who sent the tweet.
		public function setUser(theUser:String) {
			user = theUser;
		}
		
		// Sets the id of the user who sent the tweet.
		public function setUserID(id:int) {
			userID = id;
		}
		
		// Sets the text of the tweet.
		public function setTweetText(theText:String) {
			t = theText;
		}
	}
}
