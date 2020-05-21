class ApiConstants {
  static const PROJECT_NAME = '<firebase project name>';
  static const STORE_PROJECT_NAME = '<firebase store project name>';
  static const AUTH_KEY ='<firebase web api key>';
  static const MAPS_API_KEY = '<google maps api key>';

  static const URI_PATH = 'https://us-central1-$STORE_PROJECT_NAME.cloudfunctions.net/storeImage';
  static const AUTH_PATH = 'https://$PROJECT_NAME.firebaseio.com/items.json?auth=';
  static const AUTH_VERIFY_PASSWORD = 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=$AUTH_KEY';
  static const AUTH_SIGN_UP = 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=$AUTH_KEY';

}