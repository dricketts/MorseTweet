﻿package
{
	// Represents a Tweet.
	public class Tweet {
		
		private var user:String;
		private var userID:int;
		private var text:String;
		
		// Returns the user name who sent the tweet.
		public function getUser():String {
			return user;
		}
		
		// Returns the id of the user who sent the tweet.
		public function getUserID():int {
			return userID;
		}
		
		// Returns the text of the tweet.
		public function getText():String {
			return text;
		}
	}
}