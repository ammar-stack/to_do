class ToDoModal {
  int? id;
  String? todo;
  int? isdone;

  ToDoModal({this.id, this.todo, this.isdone});

  ToDoModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    todo = json['todo'];
    isdone = json['isdone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['todo'] = this.todo;
    data['isdone'] = this.isdone;
    return data;
  }
}
