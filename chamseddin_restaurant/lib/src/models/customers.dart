class Customers {
  String object;
  List<Customer> data;
  bool hasMore;
  String url;

  Customers({this.object, this.data, this.hasMore, this.url});

  Customers.fromJson(Map<String, dynamic> json) {
    object = json['object'];
    if (json['data'] != null) {
      data = new List<Customer>();
      json['data'].forEach((v) { data.add(new Customer.fromJson(v)); });
    }
    hasMore = json['has_more'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['object'] = this.object;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['has_more'] = this.hasMore;
    data['url'] = this.url;
    return data;
  }
}

class Customer {
  String id;
  String object;
  int accountBalance;
  Null address;
  int balance;
  int created;
  String currency;
  String defaultSource;
  bool delinquent;
  Null description;
  Null discount;
  String email;
  String invoicePrefix;
  bool livemode;
  Null name;
  int nextInvoiceSequence;
  Null phone;
  Null shipping;
  String taxExempt;
  Null taxInfo;
  Null taxInfoVerification;

  Customer({this.id, this.object, this.accountBalance, this.address, this.balance, this.created, this.currency, this.defaultSource, this.delinquent, this.description, this.discount, this.email, this.invoicePrefix, this.livemode, this.name, this.nextInvoiceSequence, this.phone, this.shipping, this.taxExempt, this.taxInfo, this.taxInfoVerification});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    object = json['object'];
    accountBalance = json['account_balance'];
    address = json['address'];
    balance = json['balance'];
    created = json['created'];
    currency = json['currency'];
    defaultSource = json['default_source'];
    delinquent = json['delinquent'];
    description = json['description'];
    discount = json['discount'];
    email = json['email'];
    invoicePrefix = json['invoice_prefix'];
    livemode = json['livemode'];
    name = json['name'];
    nextInvoiceSequence = json['next_invoice_sequence'];
    phone = json['phone'];
    shipping = json['shipping'];
    taxExempt = json['tax_exempt'];
    taxInfo = json['tax_info'];
    taxInfoVerification = json['tax_info_verification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['object'] = this.object;
    data['account_balance'] = this.accountBalance;
    data['address'] = this.address;
    data['balance'] = this.balance;
    data['created'] = this.created;
    data['currency'] = this.currency;
    data['default_source'] = this.defaultSource;
    data['delinquent'] = this.delinquent;
    data['description'] = this.description;
    data['discount'] = this.discount;
    data['email'] = this.email;
    data['invoice_prefix'] = this.invoicePrefix;
    data['livemode'] = this.livemode;
    data['name'] = this.name;
    data['next_invoice_sequence'] = this.nextInvoiceSequence;
    data['phone'] = this.phone;
    data['shipping'] = this.shipping;
    data['tax_exempt'] = this.taxExempt;
    data['tax_info'] = this.taxInfo;
    data['tax_info_verification'] = this.taxInfoVerification;
    return data;
  }
}
