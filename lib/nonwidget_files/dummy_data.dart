class dummy_data{
  //TODO: need to create a posts table in dynamoDB, also we are missing some things from the other tables. Disscuss later in a meeting.

  //misc
  static final String username2 = "JaneDoe987";
  static final String test_community_2 = "Leetcode"; 

  //example info from users table
  static final String profilePicture = 'assets/images/JohnDoePicture.jpg';
  static final String username = "JohnDoe123";
  static final List<String> following = ["JaneDoe987", "JimDoe456"];
  static final List<String> followers = ["JaneDoe987", "JimDoe456"];
  static int total_communities = 2;


  //example info from communities table
  static final List<String> members = ["JohnDoe123", "JaneDoe987", "JimDoe456"];


  //example info from posts table (need to decide on schema and make this still)
  static final String test_community_1 = "Spanish";
  static final String title_of_post = "Test Post 1";
  static final String postPicture = "assets/images/TestPostPicture.jpg";
  static final String dayPosted = "September 20, 2022";
  static final String post_text = "This is a test post!";
  static final int totalPosts = 5;

}