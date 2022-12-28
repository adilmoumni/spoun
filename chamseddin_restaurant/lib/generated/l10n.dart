// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get verify {
    return Intl.message(
      'Verify',
      name: 'verify',
      desc: '',
      args: [],
    );
  }

  /// `Order Id`
  String get order_id {
    return Intl.message(
      'Order Id',
      name: 'order_id',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category {
    return Intl.message(
      'Category',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `Checkout`
  String get checkout {
    return Intl.message(
      'Checkout',
      name: 'checkout',
      desc: '',
      args: [],
    );
  }

  /// `Payment Mode`
  String get payment_mode {
    return Intl.message(
      'Payment Mode',
      name: 'payment_mode',
      desc: '',
      args: [],
    );
  }

  /// `Select your preferred payment mode`
  String get select_your_preferred_payment_mode {
    return Intl.message(
      'Select your preferred payment mode',
      name: 'select_your_preferred_payment_mode',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Payment`
  String get confirm_payment {
    return Intl.message(
      'Confirm Payment',
      name: 'confirm_payment',
      desc: '',
      args: [],
    );
  }

  /// `Menu`
  String get menu {
    return Intl.message(
      'Menu',
      name: 'menu',
      desc: '',
      args: [],
    );
  }

  /// `Extras`
  String get extras {
    return Intl.message(
      'Extras',
      name: 'extras',
      desc: '',
      args: [],
    );
  }

  /// `Quantity`
  String get quantity {
    return Intl.message(
      'Quantity',
      name: 'quantity',
      desc: '',
      args: [],
    );
  }

  /// `Add to Cart`
  String get add_to_cart {
    return Intl.message(
      'Add to Cart',
      name: 'add_to_cart',
      desc: '',
      args: [],
    );
  }

  /// `FAQ`
  String get faq {
    return Intl.message(
      'FAQ',
      name: 'faq',
      desc: '',
      args: [],
    );
  }

  /// `Help & Supports`
  String get help_supports {
    return Intl.message(
      'Help & Supports',
      name: 'help_supports',
      desc: '',
      args: [],
    );
  }

  /// `App Language`
  String get app_language {
    return Intl.message(
      'App Language',
      name: 'app_language',
      desc: '',
      args: [],
    );
  }

  /// `I forgot password ?`
  String get i_forgot_password {
    return Intl.message(
      'I forgot password ?',
      name: 'i_forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `I don't have an account?`
  String get i_dont_have_an_account {
    return Intl.message(
      'I don\'t have an account?',
      name: 'i_dont_have_an_account',
      desc: '',
      args: [],
    );
  }

  /// `All Menu`
  String get all_menu {
    return Intl.message(
      'All Menu',
      name: 'all_menu',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Confirmation`
  String get confirmation {
    return Intl.message(
      'Confirmation',
      name: 'confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Your order has been successfully submitted!`
  String get your_order_has_been_successfully_submitted {
    return Intl.message(
      'Your order has been successfully submitted!',
      name: 'your_order_has_been_successfully_submitted',
      desc: '',
      args: [],
    );
  }

  /// `My Orders`
  String get my_orders {
    return Intl.message(
      'My Orders',
      name: 'my_orders',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get favorites {
    return Intl.message(
      'Favorites',
      name: 'favorites',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Payment Options`
  String get payment_options {
    return Intl.message(
      'Payment Options',
      name: 'payment_options',
      desc: '',
      args: [],
    );
  }

  /// `PayPal Payment`
  String get paypal_payment {
    return Intl.message(
      'PayPal Payment',
      name: 'paypal_payment',
      desc: '',
      args: [],
    );
  }

  /// `Recent Orders`
  String get recent_orders {
    return Intl.message(
      'Recent Orders',
      name: 'recent_orders',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Full name`
  String get full_name {
    return Intl.message(
      'Full name',
      name: 'full_name',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get phone {
    return Intl.message(
      'Phone',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Payments Settings`
  String get payments_settings {
    return Intl.message(
      'Payments Settings',
      name: 'payments_settings',
      desc: '',
      args: [],
    );
  }

  /// `App Settings`
  String get app_settings {
    return Intl.message(
      'App Settings',
      name: 'app_settings',
      desc: '',
      args: [],
    );
  }

  /// `Languages`
  String get languages {
    return Intl.message(
      'Languages',
      name: 'languages',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Help & Support`
  String get help_support {
    return Intl.message(
      'Help & Support',
      name: 'help_support',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Should be more than 3 letters`
  String get should_be_more_than_3_letters {
    return Intl.message(
      'Should be more than 3 letters',
      name: 'should_be_more_than_3_letters',
      desc: '',
      args: [],
    );
  }

  /// `Should be a valid email`
  String get should_be_a_valid_email {
    return Intl.message(
      'Should be a valid email',
      name: 'should_be_a_valid_email',
      desc: '',
      args: [],
    );
  }

  /// `Should be more than 6 letters`
  String get should_be_more_than_6_letters {
    return Intl.message(
      'Should be more than 6 letters',
      name: 'should_be_more_than_6_letters',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `I have account? Back to login`
  String get i_have_account_back_to_login {
    return Intl.message(
      'I have account? Back to login',
      name: 'i_have_account_back_to_login',
      desc: '',
      args: [],
    );
  }

  /// `Reset Cart?`
  String get reset_cart {
    return Intl.message(
      'Reset Cart?',
      name: 'reset_cart',
      desc: '',
      args: [],
    );
  }

  /// `Cart`
  String get cart {
    return Intl.message(
      'Cart',
      name: 'cart',
      desc: '',
      args: [],
    );
  }

  /// `Shopping Cart`
  String get shopping_cart {
    return Intl.message(
      'Shopping Cart',
      name: 'shopping_cart',
      desc: '',
      args: [],
    );
  }

  /// `Should be more than 3 characters`
  String get should_be_more_than_3_characters {
    return Intl.message(
      'Should be more than 3 characters',
      name: 'should_be_more_than_3_characters',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get reset {
    return Intl.message(
      'Reset',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Help & Support`
  String get help__support {
    return Intl.message(
      'Help & Support',
      name: 'help__support',
      desc: '',
      args: [],
    );
  }

  /// `Light Mode`
  String get light_mode {
    return Intl.message(
      'Light Mode',
      name: 'light_mode',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get dark_mode {
    return Intl.message(
      'Dark Mode',
      name: 'dark_mode',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get log_out {
    return Intl.message(
      'Log out',
      name: 'log_out',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get version {
    return Intl.message(
      'Version',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `Don't have any item in your cart`
  String get dont_have_any_item_in_your_cart {
    return Intl.message(
      'Don\'t have any item in your cart',
      name: 'dont_have_any_item_in_your_cart',
      desc: '',
      args: [],
    );
  }

  /// `Payment Settings`
  String get payment_settings {
    return Intl.message(
      'Payment Settings',
      name: 'payment_settings',
      desc: '',
      args: [],
    );
  }

  /// `Not a valid number`
  String get not_a_valid_number {
    return Intl.message(
      'Not a valid number',
      name: 'not_a_valid_number',
      desc: '',
      args: [],
    );
  }

  /// `Not a valid date`
  String get not_a_valid_date {
    return Intl.message(
      'Not a valid date',
      name: 'not_a_valid_date',
      desc: '',
      args: [],
    );
  }

  /// `Not a valid CVC`
  String get not_a_valid_cvc {
    return Intl.message(
      'Not a valid CVC',
      name: 'not_a_valid_cvc',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Not a valid full name`
  String get not_a_valid_full_name {
    return Intl.message(
      'Not a valid full name',
      name: 'not_a_valid_full_name',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get email_address {
    return Intl.message(
      'Email Address',
      name: 'email_address',
      desc: '',
      args: [],
    );
  }

  /// `Not a valid email`
  String get not_a_valid_email {
    return Intl.message(
      'Not a valid email',
      name: 'not_a_valid_email',
      desc: '',
      args: [],
    );
  }

  /// `Not a valid phone`
  String get not_a_valid_phone {
    return Intl.message(
      'Not a valid phone',
      name: 'not_a_valid_phone',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Recents Search`
  String get recents_search {
    return Intl.message(
      'Recents Search',
      name: 'recents_search',
      desc: '',
      args: [],
    );
  }

  /// `Verify your internet connection`
  String get verify_your_internet_connection {
    return Intl.message(
      'Verify your internet connection',
      name: 'verify_your_internet_connection',
      desc: '',
      args: [],
    );
  }

  /// `Carts refreshed successfully`
  String get carts_refreshed_successfuly {
    return Intl.message(
      'Carts refreshed successfully',
      name: 'carts_refreshed_successfuly',
      desc: '',
      args: [],
    );
  }

  /// `Restaurant refreshed successfully`
  String get restaurant_refreshed_successfuly {
    return Intl.message(
      'Restaurant refreshed successfully',
      name: 'restaurant_refreshed_successfuly',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcome {
    return Intl.message(
      'Welcome',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Wrong email or password`
  String get wrong_email_or_password {
    return Intl.message(
      'Wrong email or password',
      name: 'wrong_email_or_password',
      desc: '',
      args: [],
    );
  }

  /// `Addresses refreshed successfuly`
  String get addresses_refreshed_successfuly {
    return Intl.message(
      'Addresses refreshed successfuly',
      name: 'addresses_refreshed_successfuly',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Addresses`
  String get delivery_addresses {
    return Intl.message(
      'Delivery Addresses',
      name: 'delivery_addresses',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Email to reset password`
  String get email_to_reset_password {
    return Intl.message(
      'Email to reset password',
      name: 'email_to_reset_password',
      desc: '',
      args: [],
    );
  }

  /// `Send link`
  String get send_password_reset_link {
    return Intl.message(
      'Send link',
      name: 'send_password_reset_link',
      desc: '',
      args: [],
    );
  }

  /// `Your reset link has been sent to your email`
  String get your_reset_link_has_been_sent_to_your_email {
    return Intl.message(
      'Your reset link has been sent to your email',
      name: 'your_reset_link_has_been_sent_to_your_email',
      desc: '',
      args: [],
    );
  }

  /// `How would you rate this restaurant ?`
  String get how_would_you_rate_this_restaurant_ {
    return Intl.message(
      'How would you rate this restaurant ?',
      name: 'how_would_you_rate_this_restaurant_',
      desc: '',
      args: [],
    );
  }

  /// `The food has been rated successfully`
  String get the_food_has_been_rated_successfully {
    return Intl.message(
      'The food has been rated successfully',
      name: 'the_food_has_been_rated_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Reviews refreshed successfully!`
  String get reviews_refreshed_successfully {
    return Intl.message(
      'Reviews refreshed successfully!',
      name: 'reviews_refreshed_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Payment card updated successfully`
  String get payment_card_updated_successfully {
    return Intl.message(
      'Payment card updated successfully',
      name: 'payment_card_updated_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get open {
    return Intl.message(
      'Open',
      name: 'open',
      desc: '',
      args: [],
    );
  }

  /// `Restaurants near to your current location`
  String get restaurants_near_to_your_current_location {
    return Intl.message(
      'Restaurants near to your current location',
      name: 'restaurants_near_to_your_current_location',
      desc: '',
      args: [],
    );
  }

  /// `Restaurants near to`
  String get restaurants_near_to {
    return Intl.message(
      'Restaurants near to',
      name: 'restaurants_near_to',
      desc: '',
      args: [],
    );
  }

  /// `Pickup your food from the restaurant`
  String get pickup_your_food_from_the_restaurant {
    return Intl.message(
      'Pickup your food from the restaurant',
      name: 'pickup_your_food_from_the_restaurant',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter {
    return Intl.message(
      'Filter',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message(
      'Clear',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `Apply Filters`
  String get apply_filters {
    return Intl.message(
      'Apply Filters',
      name: 'apply_filters',
      desc: '',
      args: [],
    );
  }

  /// `This food was added to cart`
  String get this_food_was_added_to_cart {
    return Intl.message(
      'This food was added to cart',
      name: 'this_food_was_added_to_cart',
      desc: '',
      args: [],
    );
  }

  /// `This email account exists`
  String get this_email_account_exists {
    return Intl.message(
      'This email account exists',
      name: 'this_email_account_exists',
      desc: '',
      args: [],
    );
  }

  /// `This account not exist`
  String get this_account_not_exist {
    return Intl.message(
      'This account not exist',
      name: 'this_account_not_exist',
      desc: '',
      args: [],
    );
  }

  /// `CARD NUMBER`
  String get card_number {
    return Intl.message(
      'CARD NUMBER',
      name: 'card_number',
      desc: '',
      args: [],
    );
  }

  /// `EXPIRY DATE`
  String get expiry_date {
    return Intl.message(
      'EXPIRY DATE',
      name: 'expiry_date',
      desc: '',
      args: [],
    );
  }

  /// `CVV`
  String get cvv {
    return Intl.message(
      'CVV',
      name: 'cvv',
      desc: '',
      args: [],
    );
  }

  /// `Your credit card not valid`
  String get your_credit_card_not_valid {
    return Intl.message(
      'Your credit card not valid',
      name: 'your_credit_card_not_valid',
      desc: '',
      args: [],
    );
  }

  /// `Number`
  String get number {
    return Intl.message(
      'Number',
      name: 'number',
      desc: '',
      args: [],
    );
  }

  /// `Exp Date`
  String get exp_date {
    return Intl.message(
      'Exp Date',
      name: 'exp_date',
      desc: '',
      args: [],
    );
  }

  /// `CVC`
  String get cvc {
    return Intl.message(
      'CVC',
      name: 'cvc',
      desc: '',
      args: [],
    );
  }

  /// `Cuisines`
  String get cuisines {
    return Intl.message(
      'Cuisines',
      name: 'cuisines',
      desc: '',
      args: [],
    );
  }

  /// `Favorites refreshed successfully`
  String get favorites_refreshed_successfuly {
    return Intl.message(
      'Favorites refreshed successfully',
      name: 'favorites_refreshed_successfuly',
      desc: '',
      args: [],
    );
  }

  /// `This food was added to favorite`
  String get thisFoodWasAddedToFavorite {
    return Intl.message(
      'This food was added to favorite',
      name: 'thisFoodWasAddedToFavorite',
      desc: '',
      args: [],
    );
  }

  /// `This food was removed from favorites`
  String get thisFoodWasRemovedFromFavorites {
    return Intl.message(
      'This food was removed from favorites',
      name: 'thisFoodWasRemovedFromFavorites',
      desc: '',
      args: [],
    );
  }

  /// `View Details`
  String get viewDetails {
    return Intl.message(
      'View Details',
      name: 'viewDetails',
      desc: '',
      args: [],
    );
  }

  /// `You don't  have any order`
  String get youDontHaveAnyOrder {
    return Intl.message(
      'You don\'t  have any order',
      name: 'youDontHaveAnyOrder',
      desc: '',
      args: [],
    );
  }

  /// `Order Details`
  String get orderDetails {
    return Intl.message(
      'Order Details',
      name: 'orderDetails',
      desc: '',
      args: [],
    );
  }

  /// `Order`
  String get order {
    return Intl.message(
      'Order',
      name: 'order',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get details {
    return Intl.message(
      'Details',
      name: 'details',
      desc: '',
      args: [],
    );
  }

  /// `Canceled`
  String get canceled {
    return Intl.message(
      'Canceled',
      name: 'canceled',
      desc: '',
      args: [],
    );
  }

  /// `View`
  String get view {
    return Intl.message(
      'View',
      name: 'view',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Tap again to leave`
  String get tapAgainToLeave {
    return Intl.message(
      'Tap again to leave',
      name: 'tapAgainToLeave',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get help {
    return Intl.message(
      'Help',
      name: 'help',
      desc: '',
      args: [],
    );
  }

  /// `Preferred meals`
  String get preferredMeals {
    return Intl.message(
      'Preferred meals',
      name: 'preferredMeals',
      desc: '',
      args: [],
    );
  }

  /// `Restaurants`
  String get restaurants {
    return Intl.message(
      'Restaurants',
      name: 'restaurants',
      desc: '',
      args: [],
    );
  }

  String get select_payment_method_to_place_order {
    return Intl.message(
      'Select payment method to place order',
      name: 'select_payment_method_to_place_order',
      desc: '',
      args: [],
    );
  }

  String get final_payment {
    return Intl.message(
      'Final Payment',
      name: 'final_payment',
      desc: '',
      args: [],
    );
  }


  String get specificInsturctions {
    return Intl.message(
      'Specific Instructions',
      name: 'specificInstructions',
      desc: '',
      args: [],
    );
  }

  /// `Your restaurant\nanywhere you are.`
  String get yourRestaurantnanywhereYouAre {
    return Intl.message(
      'Your restaurant\nanywhere you are.',
      name: 'yourRestaurantnanywhereYouAre',
      desc: '',
      args: [],
    );
  }

  String get orderAgain {
    return Intl.message("Order Again",
    name: 'orderAgain',
    desc: '',
    args: []
    );
  }

  String get orderId {
    return Intl.message("Order ID",
        name: 'orderId',
        desc: '',
        args: []
    );
  }

  /// `Forgot your password?`
  String get forgotYourPassword {
    return Intl.message(
      'Forgot your password?',
      name: 'forgotYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Continue with facebook`
  String get continue_with_facebook {
    return Intl.message(
      'Continue with facebook',
      name: 'continue_with_facebook',
      desc: '',
      args: [],
    );
  }

  /// `Continue with google`
  String get continue_with_google {
    return Intl.message(
      'Continue with google',
      name: 'continue_with_google',
      desc: '',
      args: [],
    );
  }

  /// `--    OR SIGN UP    --`
  String get or_signup {
    return Intl.message(
      '--    OR SIGN UP    --',
      name: 'or_signup',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get dont_have_an_account {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dont_have_an_account',
      desc: '',
      args: [],
    );
  }

  /// ` Sign up`
  String get signup {
    return Intl.message(
      ' Sign up',
      name: 'signup',
      desc: '',
      args: [],
    );
  }

  /// `Registration`
  String get registration {
    return Intl.message(
      'Registration',
      name: 'registration',
      desc: '',
      args: [],
    );
  }

  /// `Enter your number.\n'           'We will send you a verification code`
  String get enterYourNumber {
    return Intl.message(
      'Enter your number.\n\'           \'We will send you a verification code',
      name: 'enterYourNumber',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Verification`
  String get verification {
    return Intl.message(
      'Verification',
      name: 'verification',
      desc: '',
      args: [],
    );
  }

  /// `Didn't you receive the code ?`
  String get didntYouReceiveTheCode {
    return Intl.message(
      'Didn\'t you receive the code ?',
      name: 'didntYouReceiveTheCode',
      desc: '',
      args: [],
    );
  }

  /// `Resend a new code.`
  String get resent_a_new_code {
    return Intl.message(
      'Resend a new code.',
      name: 'resent_a_new_code',
      desc: '',
      args: [],
    );
  }

  /// `Create an account`
  String get create_an_account {
    return Intl.message(
      'Create an account',
      name: 'create_an_account',
      desc: '',
      args: [],
    );
  }

  /// `Only 10 tentaives are possible.`
  String get only_10_tentatives_possible {
    return Intl.message(
      'Only 10 tentaives are possible.',
      name: 'only_10_tentatives_possible',
      desc: '',
      args: [],
    );
  }

  /// `My Account`
  String get my_account {
    return Intl.message(
      'My Account',
      name: 'my_account',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method`
  String get payment_method {
    return Intl.message(
      'Payment Method',
      name: 'payment_method',
      desc: '',
      args: [],
    );
  }

  /// `Change my Password`
  String get change_my_password {
    return Intl.message(
      'Change my Password',
      name: 'change_my_password',
      desc: '',
      args: [],
    );
  }

  /// `Customer Service`
  String get customer_service {
    return Intl.message(
      'Customer Service',
      name: 'customer_service',
      desc: '',
      args: [],
    );
  }

  /// `Terms & Conditions`
  String get terms_and_conditions {
    return Intl.message(
      'Terms & Conditions',
      name: 'terms_and_conditions',
      desc: '',
      args: [],
    );
  }

  /// `Check Out`
  String get check_out {
    return Intl.message(
      'Check Out',
      name: 'check_out',
      desc: '',
      args: [],
    );
  }

  /// `Add Preferred meal`
  String get add_preferred_meals {
    return Intl.message(
      'Add Preferred meal',
      name: 'add_preferred_meals',
      desc: '',
      args: [],
    );
  }

  /// `My cart`
  String get my_cart {
    return Intl.message(
      'My cart',
      name: 'my_cart',
      desc: '',
      args: [],
    );
  }

  /// `Service Fee`
  String get service_fee {
    return Intl.message(
      'Service Fee',
      name: 'service_fee',
      desc: '',
      args: [],
    );
  }

  /// `VAT`
  String get vat {
    return Intl.message(
      'VAT',
      name: 'vat',
      desc: '',
      args: [],
    );
  }

  /// `Grand Total`
  String get grand_total {
    return Intl.message(
      'Grand Total',
      name: 'grand_total',
      desc: '',
      args: [],
    );
  }

  /// `Sous_total`
  String get sous_total {
    return Intl.message(
      'Sous_total',
      name: 'sous_total',
      desc: '',
      args: [],
    );
  }

  /// `Discount`
  String get discount {
    return Intl.message(
      'Discount',
      name: 'discount',
      desc: '',
      args: [],
    );
  }

  /// `Restaurant total`
  String get restaurant_total {
    return Intl.message(
      'Restaurant total',
      name: 'restaurant_total',
      desc: '',
      args: [],
    );
  }

  /// `Promotion Code`
  String get promotion_code {
    return Intl.message(
      'Promotion Code',
      name: 'promotion_code',
      desc: '',
      args: [],
    );
  }

  /// `Specific instructions`
  String get specific_instructions {
    return Intl.message(
      'Specific instructions',
      name: 'specific_instructions',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get first_name {
    return Intl.message(
      'First Name',
      name: 'first_name',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get last_name {
    return Intl.message(
      'Last Name',
      name: 'last_name',
      desc: '',
      args: [],
    );
  }

  /// `Country (optional)`
  String get country {
    return Intl.message(
      'Country (optional)',
      name: 'country',
      desc: '',
      args: [],
    );
  }

  /// `Birthdate (optional)`
  String get birthdate {
    return Intl.message(
      'Birthdate (optional)',
      name: 'birthdate',
      desc: '',
      args: [],
    );
  }

  /// `By signing up you agree to our Terms of Use and Privacy Policy`
  String get by_signing_up {
    return Intl.message(
      'By signing up you agree to our Terms of Use and Privacy Policy',
      name: 'by_signing_up',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message(
      'Apply',
      name: 'apply',
      desc: '',
      args: [],
    );
  }

  /// `My Account`
  String get myAccount {
    return Intl.message(
      'My Account',
      name: 'myAccount',
      desc: '',
      args: [],
    );
  }

  /// `Mobile`
  String get mobile {
    return Intl.message(
      'Mobile',
      name: 'mobile',
      desc: '',
      args: [],
    );
  }

  /// `Change my password`
  String get changeMyPassword {
    return Intl.message(
      'Change my password',
      name: 'changeMyPassword',
      desc: '',
      args: [],
    );
  }

  String get areYouSure {
    return Intl.message(
      'Are you sure',
      name: 'areYouSure',
      desc: '',
      args: [],
    );
  }

  String get doYouWantTo {
    // Do you want to remove item from favourite
    return Intl.message(
      'Do you want to remove item from favourite',
      name: 'doYouWantTo',
      desc: '',
      args: [],
    );
  }

  /// `Old Password`
  String get oldPassword {
    return Intl.message(
      'Old Password',
      name: 'oldPassword',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm new Password`
  String get confirmNewPassword {
    return Intl.message(
      'Confirm new Password',
      name: 'confirmNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Forgotten password`
  String get forgottenPassword {
    return Intl.message(
      'Forgotten password',
      name: 'forgottenPassword',
      desc: '',
      args: [],
    );
  }

  /// `Total Payment`
  String get totalPayment {
    return Intl.message(
      'Total Payment',
      name: 'totalPayment',
      desc: '',
      args: [],
    );
  }

  /// `Show QR Code`
  String get showQrCode {
    return Intl.message(
      'Show QR Code',
      name: 'showQrCode',
      desc: '',
      args: [],
    );
  }

  /// `Rate Diner`
  String get rateDiner {
    return Intl.message(
      'Rate Diner',
      name: 'rateDiner',
      desc: '',
      args: [],
    );
  }

  /// `Final Payment`
  String get finalPayment {
    return Intl.message(
      'Final Payment',
      name: 'finalPayment',
      desc: '',
      args: [],
    );
  }

  /// `My QR Code`
  String get myQrCode {
    return Intl.message(
      'My QR Code',
      name: 'myQrCode',
      desc: '',
      args: [],
    );
  }

  /// `QR Code for your order is :`
  String get qrCodeForYourOrderIs {
    return Intl.message(
      'QR Code for your order is :',
      name: 'qrCodeForYourOrderIs',
      desc: '',
      args: [],
    );
  }

  /// `Report Issue`
  String get reportIssue {
    return Intl.message(
      'Report Issue',
      name: 'reportIssue',
      desc: '',
      args: [],
    );
  }

  /// `Unable to generate QR code`
  String get unableToGenerateQrCode {
    return Intl.message(
      'Unable to generate QR code',
      name: 'unableToGenerateQrCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter your number.\n'           'We will send you a verification code`
  String get enter_your_number {
    return Intl.message(
      'Enter your number.\n\'           \'We will send you a verification code',
      name: 'enter_your_number',
      desc: '',
      args: [],
    );
  }

  /// `Dining areas near you`
  String get dining_areas_near_you {
    return Intl.message(
      'Dining areas near you',
      name: 'dining_areas_near_you',
      desc: '',
      args: [],
    );
  }

  /// `Change Language`
  String get change_language {
    return Intl.message(
      'Change Language',
      name: 'change_language',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}