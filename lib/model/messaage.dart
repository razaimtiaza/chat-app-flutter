class AutoGenerate {
  AutoGenerate({
    required this.formid,
    required this.msg,
    required this.read,
    required this.sent,
    required this.told,
    required this.type,
  });
  late final String formid;
  late final String msg;
  late final String read;
  late final String sent;
  late final String told;
  late final Type type;

  AutoGenerate.fromJson(Map<String, dynamic> json){
    formid = json['formid'].toString();
    msg = json['msg'].toString();
    read = json['read'].toString();
    sent = json['sent'].toString();
    told = json['told'].toString();
    type = json['type'].toString()==Type.image.name?Type.image:Type.text;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['formid'] = formid;
    _data['msg'] = msg;
    _data['read'] = read;
    _data['sent'] = sent;
    _data['told'] = told;
    _data['type'] = type.name;
    return _data;
  }

}
enum Type{ text,image}