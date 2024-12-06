import 'package:ecommerce_app_fluterr_nodejs/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: '',
    name: '',
    email: '',
    password: '',
    address: '',
    type: '',
    token: '',
    cart: [],
    followers: [],
    following: [],
  );

  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }

  // Thêm seller vào danh sách following
  void followSeller(String sellerId) {
    if (!_user.following.contains(sellerId)) {
      _user = _user.copyWith(
        following: [..._user.following, sellerId],
      );
      notifyListeners();
    }
  }

  // Xóa seller khỏi danh sách following
  void unfollowSeller(String sellerId) {
    _user = _user.copyWith(
      following: _user.following.where((id) => id != sellerId).toList(),
    );
    notifyListeners();
  }

  // Cập nhật toàn bộ danh sách following
  void updateFollowing(List<String> following) {
    _user = _user.copyWith(following: following);
    notifyListeners();
  }

  // Cập nhật toàn bộ danh sách followers
  void updateFollowers(List<String> followers) {
    _user = _user.copyWith(followers: followers);
    notifyListeners();
  }

  // Kiểm tra xem user hiện tại có đang follow một seller không
  bool isFollowing(String sellerId) {
    return _user.following.contains(sellerId);
  }
}