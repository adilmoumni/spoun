import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';

class StripePaymentWidget extends StatefulWidget{
  ValueChanged<PaymentMethod> onChanged;

  StripePaymentWidget({
    this.onChanged,
    Key key,
  }) : super(key: key);

  @override
  _StripePaymentWidgetState createState() => _StripePaymentWidgetState(onChanged);
}

class _StripePaymentWidgetState extends State<StripePaymentWidget>{
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String _error;
  ValueChanged<PaymentMethod> onChanged;

  _StripePaymentWidgetState(ValueChanged<PaymentMethod> onChanged){
    this.onChanged=onChanged;
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
      child: RaisedButton(
        child: Text("Add Card", textAlign: TextAlign.center,),
        onPressed: () {
          StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest()).then((paymentMethod) {
            onChanged(paymentMethod);
          }).catchError(setError);
        },
      ),
    );
  }

  void setError(dynamic error) {
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text(error.toString())));
    setState(() {
      _error = error.toString();
    });
  }

}