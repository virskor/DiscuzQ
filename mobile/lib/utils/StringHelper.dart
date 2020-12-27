class StringHelper {
  static bool isEmpty({String string}) {
    if (string == null) {
      return true;
    }

    if(string.trim() == ""){
      return true;
    }

    return false;
  }
}
