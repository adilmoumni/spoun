import '../controllers/payment_cards_controller.dart';

class PaypalArguments {
  final PaymentCompletedCallback paymentCompletedCallback;
  final double totalAmount;

  PaypalArguments(this.paymentCompletedCallback, this.totalAmount);
}
