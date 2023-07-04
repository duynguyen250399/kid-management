import 'package:kid_management/src/fake-data/SocketUtils.dart';
import 'package:kid_management/src/fake-data/UserSocket.dart';

class Global {
  // Socket
  static SocketUtils socketUtilParent;
  static SocketUtils socketUtilKid;
  static int kidId = 0;
  static int parentId = 0;
  // Logged In User
  static UserSocket parentUser;

  // Single Chat - To Chat User
  static UserSocket kidUser;

  static initParentSocket() {
    if (null == socketUtilParent) {
      socketUtilParent = SocketUtils();
    }
  }

  static initKidSocket() {
    if (null == socketUtilKid) {
      socketUtilKid = SocketUtils();
    }
  }

  static UserSocket initParentUser() {
    parentUser =
        new UserSocket(id: parentId, email: "parent@gmail.com", isParent: true);
    return parentUser;
  }

  static UserSocket initKidUsers() {
    kidUser = new UserSocket(
        id: kidId, email: 'forkid@kidspace.com', isParent: false);
    return kidUser;
  }
}
