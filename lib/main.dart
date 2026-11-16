import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const BareeqApp());

class Ingredient {
  String name;
  double? percent;
  String? note;
  Ingredient(this.name, this.percent, {this.note});
  Map<String, dynamic> toJson() => {'name': name, 'percent': percent, 'note': note};
  factory Ingredient.fromJson(Map<String, dynamic> j) => Ingredient(
    j['name'] as String,
    (j['percent'] as num?)?.toDouble(),
    note: j['note'] as String?,
  );
}

class Recipe {
  String name;
  List<Ingredient> ingredients;
  Recipe(this.name, this.ingredients);
  Map<String, dynamic> toJson() => {
    'name': name,
    'ingredients': ingredients.map((e) => e.toJson()).toList(),
  };
  factory Recipe.fromJson(Map<String, dynamic> j) => Recipe(
    j['name'] as String,
    (j['ingredients'] as List).map((e) => Ingredient.fromJson(Map<String, dynamic>.from(e))).toList(),
  );
}


class LedgerEntry {
  String id, kind, item, party, note, invoiceNo;
  double quantity, unitPrice;
  DateTime date;
  LedgerEntry({required this.id,required this.kind,required this.item,required this.party,
    required this.note,required this.invoiceNo,required this.quantity,required this.unitPrice,required this.date});
  double get total => quantity * unitPrice;
  Map<String,dynamic> toJson()=>{'id':id,'kind':kind,'item':item,'party':party,'note':note,
    'invoiceNo':invoiceNo,'quantity':quantity,'unitPrice':unitPrice,'date':date.toIso8601String()};
  factory LedgerEntry.fromJson(Map<String,dynamic> j)=>LedgerEntry(
    id:j['id'],kind:j['kind'],item:j['item']??'',party:j['party']??'',note:j['note']??'',invoiceNo:j['invoiceNo']??'',
    quantity:(j['quantity'] as num).toDouble(),unitPrice:(j['unitPrice'] as num).toDouble(),
    date:DateTime.tryParse(j['date']??'')??DateTime.now());
}

List<Recipe> defaultRecipes() => [
  Recipe('بيريل أصفر', [
    Ingredient('تكسابون',10), Ingredient('سلفونيك',8), Ingredient('بيتاين',5),
    Ingredient('ملح',2), Ingredient('عطر',.5), Ingredient('لون',.02),
    Ingredient('مادة حافظة',.2), Ingredient('ماء',74.28),
  ]),
  Recipe('بيريل أخضر', [
    Ingredient('ماء منزوع الأملاح',70.78), Ingredient('تكسابون N70',12),
    Ingredient('سلفونيك',8), Ingredient('بيتاين',5), Ingredient('جلسرين',1),
    Ingredient('كربونات صوديوم',1), Ingredient('ملح',1.5),
    Ingredient('مادة حافظة',.3), Ingredient('عطر ليمون/أخضر',.4), Ingredient('لون أخضر',.02),
  ]),
  Recipe('بيريل خوخي', [
    Ingredient('ماء منزوع الأملاح',70.78), Ingredient('تكسابون N70',12),
    Ingredient('سلفونيك',8), Ingredient('بيتاين',5), Ingredient('جلسرين',1),
    Ingredient('كربونات صوديوم',1), Ingredient('ملح',1.5),
    Ingredient('مادة حافظة',.3), Ingredient('عطر خوخ',.4), Ingredient('لون خوخي',.02),
  ]),
  Recipe('برسيل جل', [
    Ingredient('ماء منزوع الأملاح',67.68), Ingredient('تكسابون N70',12),
    Ingredient('سلفونيك',10), Ingredient('بيتاين',3), Ingredient('كربونات صوديوم',2),
    Ingredient('سيترات صوديوم',2), Ingredient('ملح',2.5), Ingredient('مادة حافظة',.3),
    Ingredient('عطر',.5), Ingredient('لون',.02),
  ]),
  Recipe('باهي جل', [
    Ingredient('ماء منزوع الأملاح*',72), Ingredient('تكسابون N70',10),
    Ingredient('سلفونيك',8), Ingredient('بيتاين',3), Ingredient('كربونات صوديوم',2),
    Ingredient('سيترات صوديوم',2), Ingredient('ملح',2), Ingredient('مادة حافظة',.3),
    Ingredient('عطر',.5), Ingredient('لون',.02), Ingredient('محلول تعادل/صودا كاوية',null,note:'حسب pH'),
  ]),
  Recipe('أريال جل اتوماتيك', [
    Ingredient('ماء منزوع الأملاح',74.68), Ingredient('تكسابون N70',8),
    Ingredient('سلفونيك',8), Ingredient('خافض رغوة/منخفض الرغوة',3),
    Ingredient('كربونات صوديوم',2), Ingredient('سيترات صوديوم',2), Ingredient('ملح',1.5),
    Ingredient('مادة حافظة',.3), Ingredient('عطر',.5), Ingredient('لون',.02),
  ]),
  Recipe('فانش', [
    Ingredient('ماء منزوع الأملاح',88.68), Ingredient('بيركربونات الصوديوم',5),
    Ingredient('تكسابون N70',2), Ingredient('بيتاين',1), Ingredient('سيترات الصوديوم',2),
    Ingredient('كربونات الصوديوم',1), Ingredient('مادة حافظة مناسبة',.2),
    Ingredient('عطر',.1), Ingredient('لون',.02),
  ]),
  Recipe('فلاش', [
    Ingredient('ماء منزوع الأملاح',91.18), Ingredient('تكسابون N70',3),
    Ingredient('سلفونيك',2), Ingredient('بيتاين',1), Ingredient('كحول إيثيلي',1),
    Ingredient('كربونات صوديوم',1), Ingredient('مادة حافظة',.3), Ingredient('عطر',.5), Ingredient('لون',.02),
  ]),
  Recipe('دوني', [
    Ingredient('ماء منزوع الأملاح*',94.18), Ingredient('مادة منعم كاتيونية مناسبة',4),
    Ingredient('جلسرين',.5), Ingredient('مادة حافظة',.3), Ingredient('عطر',.8),
    Ingredient('لون',.02), Ingredient('ضبط pH',null,note:'حسب القياس'),
  ]),
  Recipe('هاربيك', [
    Ingredient('ماء منزوع الأملاح',93.18), Ingredient('تكسابون N70',2),
    Ingredient('بيتاين',2), Ingredient('سلفونيك',1), Ingredient('كربونات صوديوم',1),
    Ingredient('مادة حافظة',.3), Ingredient('عطر',.5), Ingredient('لون',.02),
  ]),
  Recipe('باور دهون', [
    Ingredient('ماء منزوع الأملاح',90.18), Ingredient('تكسابون N70',3),
    Ingredient('سلفونيك',2), Ingredient('بيتاين',1), Ingredient('كربونات صوديوم',2),
    Ingredient('بيكربونات صوديوم',1), Ingredient('مادة حافظة',.3), Ingredient('عطر',.5), Ingredient('لون',.02),
  ]),
  Recipe('شامبو', [
    Ingredient('ماء منزوع الأملاح',73.3), Ingredient('تكسابون N70',15),
    Ingredient('بيتاين',8), Ingredient('جلسرين',2), Ingredient('مادة حافظة مناسبة',.5),
    Ingredient('عطر مناسب للشامبو',.5), Ingredient('ملح',.5), Ingredient('لون',.02), Ingredient('منظم pH',.18),
  ]),
  Recipe('شاور', [
    Ingredient('ماء منزوع الأملاح*',72.48), Ingredient('تكسابون N70',15),
    Ingredient('بيتاين',8), Ingredient('جلسرين',3), Ingredient('مادة حافظة مناسبة',.5),
    Ingredient('عطر',.5), Ingredient('ملح',.5), Ingredient('لون',.02),
    Ingredient('منظم pH',null,note:'حسب القياس'),
  ]),
  Recipe('بلسم', [
    Ingredient('ماء منزوع الأملاح',84.17), Ingredient('BTMS-50',5),
    Ingredient('كحول سيتيل',3), Ingredient('كحول ستياريلي',2), Ingredient('جلسرين',3),
    Ingredient('زيت/سيليكون مناسب للشعر',2), Ingredient('مادة حافظة مناسبة',.5),
    Ingredient('عطر',.3), Ingredient('حمض الستريك/منظم pH',.02), Ingredient('لون',.01),
  ]),
  Recipe('معطر ارضيات', [
    Ingredient('ماء منزوع الأملاح',92), Ingredient('عطر مناسب للأرضيات',2),
    Ingredient('كحول إيثيلي',3), Ingredient('بيتاين',1), Ingredient('مذيب للعطر',1),
    Ingredient('مادة حافظة',.2), Ingredient('لون',.02), Ingredient('ماء متبقي',.78),
  ]),
  Recipe('معطر جو', [
    Ingredient('ماء مقطر/منزوع الأملاح',90), Ingredient('كحول إيثيلي',7),
    Ingredient('عطر مركز مناسب',2), Ingredient('مذيب للعطر مثل Polysorbate 20',.8),
    Ingredient('مادة حافظة مناسبة',.2),
  ]),
];

class BareeqApp extends StatefulWidget {
  const BareeqApp({super.key});
  @override State<BareeqApp> createState() => _BareeqAppState();
}
class _BareeqAppState extends State<BareeqApp> {
  List<Recipe> recipes = defaultRecipes();
  Map<String,double> prices = {};
  List<LedgerEntry> entries = [];
  bool loaded = false;

  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString('bareeq_recipes_v2');
    if (raw != null) {
      try { recipes = (jsonDecode(raw) as List).map((e) => Recipe.fromJson(Map<String,dynamic>.from(e))).toList(); } catch (_) {}
    }
    final er = p.getString('bareeq_ledger_v1');
    if (er != null) { try { entries = (jsonDecode(er) as List).map((e)=>LedgerEntry.fromJson(Map<String,dynamic>.from(e))).toList(); } catch (_) {} }
    final pr = p.getString('bareeq_prices_v2');
    if (pr != null) {
      try { prices = (jsonDecode(pr) as Map<String,dynamic>).map((k,v) => MapEntry(k,(v as num).toDouble())); } catch (_) {}
    }
    if (mounted) setState(() => loaded = true);
  }
  Future<void> save() async {
    final p = await SharedPreferences.getInstance();
    await p.setString('bareeq_recipes_v2', jsonEncode(recipes.map((e)=>e.toJson()).toList()));
    await p.setString('bareeq_prices_v2', jsonEncode(prices));
    await p.setString('bareeq_ledger_v1', jsonEncode(entries.map((e)=>e.toJson()).toList()));
  }
  @override Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner:false, title:'بريق',
    theme: ThemeData(useMaterial3:true, colorScheme:ColorScheme.fromSeed(seedColor:const Color(0xff087f75)), scaffoldBackgroundColor:const Color(0xfff4f7f7)),
    home: loaded ? HomePage(recipes:recipes, prices:prices, entries:entries, onSave:save) : const Scaffold(body:Center(child:CircularProgressIndicator())),
  );
}

class HomePage extends StatefulWidget {
  final List<Recipe> recipes; final Map<String,double> prices; final List<LedgerEntry> entries; final Future<void> Function() onSave;
  const HomePage({super.key,required this.recipes,required this.prices,required this.entries,required this.onSave});
  @override State<HomePage> createState()=>_HomePageState();
}
class _HomePageState extends State<HomePage> {
  int tab=0; String? selected; final qty=TextEditingController(text:'1'); final sale=TextEditingController();
  double? batchKg;
  @override void initState(){super.initState(); selected=widget.recipes.first.name;}
  @override void dispose(){qty.dispose();sale.dispose();super.dispose();}
  Recipe get recipe=>widget.recipes.firstWhere((r)=>r.name==selected,orElse:()=>widget.recipes.first);
  double? get quantity=>double.tryParse(qty.text.trim().replaceAll(',','.'));
  double grams(double p)=>p/100*(quantity??0)*1000;
  double get totalCost=>recipe.ingredients.fold(0,(s,i)=>s+(i.percent==null?0:(grams(i.percent!)/1000)*(widget.prices[i.name]??0)));
  Future<void> refreshSave() async { await widget.onSave(); if(mounted)setState((){}); }
  @override Widget build(BuildContext context)=>Directionality(textDirection:TextDirection.rtl,child:Scaffold(
    appBar:AppBar(title:const Text('بريق | إدارة تصنيع المنظفات'),centerTitle:true,backgroundColor:const Color(0xff087f75),foregroundColor:Colors.white),
    body:IndexedStack(index:tab,children:[_calculator(),_recipes(),_prices(),_accounts()]),
    bottomNavigationBar:NavigationBar(selectedIndex:tab,onDestinationSelected:(v)=>setState(()=>tab=v),destinations:const[
      NavigationDestination(icon:Icon(Icons.calculate_outlined),selectedIcon:Icon(Icons.calculate),label:'الحاسبة'),
      NavigationDestination(icon:Icon(Icons.science_outlined),selectedIcon:Icon(Icons.science),label:'التركيبات'),
      NavigationDestination(icon:Icon(Icons.payments_outlined),selectedIcon:Icon(Icons.payments),label:'أسعار الخامات'),
      NavigationDestination(icon:Icon(Icons.account_balance_wallet_outlined),selectedIcon:Icon(Icons.account_balance_wallet),label:'الحسابات'),
    ]),
  ));
  Widget _card(Widget child)=>Card(child:Padding(padding:const EdgeInsets.all(14),child:child));
  Widget _calculator()=>ListView(padding:const EdgeInsets.all(14),children:[
    _card(Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
      const Text('حساب كميات التصنيع',style:TextStyle(fontSize:19,fontWeight:FontWeight.bold)),
      const SizedBox(height:12),DropdownButtonFormField<String>(value:selected,decoration:const InputDecoration(labelText:'اختر المنتج',border:OutlineInputBorder()),items:widget.recipes.map((r)=>DropdownMenuItem(value:r.name,child:Text(r.name))).toList(),onChanged:(v)=>setState(()=>selected=v)),
      const SizedBox(height:10),TextField(controller:qty,keyboardType:const TextInputType.numberWithOptions(decimal:true),decoration:const InputDecoration(labelText:'كمية الإنتاج بالكيلو',border:OutlineInputBorder()),onChanged:(_)=>setState(()=>batchKg=null)),
      const SizedBox(height:12),FilledButton.icon(onPressed:(){if(quantity==null||quantity!<=0){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('أدخل كمية أكبر من صفر')));return;}setState(()=>batchKg=quantity);},icon:const Icon(Icons.calculate),label:const Text('احسب الخامات')),
    ])),
    if(batchKg!=null)...[
      _card(Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
        Text('خامات ${recipe.name} لكمية ${batchKg!.toStringAsFixed(3)} كجم',style:const TextStyle(fontWeight:FontWeight.bold,fontSize:17)),
        const SizedBox(height:8),
        ...recipe.ingredients.map((i)=>ListTile(contentPadding:EdgeInsets.zero,title:Text(i.name),subtitle:Text(i.percent==null?(i.note??'يحدد حسب القياس'):'${i.percent}% من التركيبة'),trailing:Text(i.percent==null?'حسب القياس':'${grams(i.percent!).toStringAsFixed(2)} جم',style:const TextStyle(fontWeight:FontWeight.bold)))),
        const Divider(),Text('تكلفة الخامات المسعّرة: ${totalCost.toStringAsFixed(2)} جنيه',style:const TextStyle(fontWeight:FontWeight.bold,color:Color(0xff087f75))),
        Text('التكلفة لكل كيلو: ${(totalCost/batchKg!).toStringAsFixed(2)} جنيه'),
        const SizedBox(height:8),TextField(controller:sale,keyboardType:const TextInputType.numberWithOptions(decimal:true),decoration:const InputDecoration(labelText:'سعر بيع الكيلو (اختياري)',suffixText:'جنيه',border:OutlineInputBorder()),onChanged:(_)=>setState((){})),
        if(double.tryParse(sale.text.replaceAll(',','.'))!=null)...[
          const SizedBox(height:6),Text('الفرق قبل المصروفات: ${((double.parse(sale.text.replaceAll(',','.'))*batchKg!)-totalCost).toStringAsFixed(2)} جنيه',style:const TextStyle(fontWeight:FontWeight.bold)),
        ],
      ])),
      _card(const Text('أي خامة بدون سعر مسجل لا تدخل في إجمالي التكلفة. أدخل أسعار الخامات من تبويب «أسعار الخامات».',style:TextStyle(color:Colors.black54))),
    ],
    _card(const Text('تنبيه: الحسابات تنقل نسب التركيبات المسجلة كما هي ولا تمثل اعتمادًا فنيًا للتركيبة. يجب اختبار الجودة ودرجة الحموضة والثبات والتوافق والسلامة قبل التصنيع أو البيع.',style:TextStyle(color:Color(0xff795600)))),
  ]);
  Widget _recipes()=>ListView(padding:const EdgeInsets.all(14),children:[
    Row(children:[const Expanded(child:Text('إدارة التركيبات',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold))),FilledButton.icon(onPressed:()=>_editRecipe(),icon:const Icon(Icons.add),label:const Text('منتج جديد'))]),
    const SizedBox(height:8),
    ...widget.recipes.map((r)=>Card(child:ExpansionTile(title:Text(r.name,style:const TextStyle(fontWeight:FontWeight.bold)),subtitle:Text('${r.ingredients.length} خامة'),children:[
      ...r.ingredients.map((i)=>ListTile(dense:true,title:Text(i.name),trailing:Text(i.percent==null?(i.note??'حسب القياس'):'${i.percent}%'))),
      Padding(padding:const EdgeInsets.fromLTRB(12,0,12,12),child:Wrap(spacing:8,children:[
        OutlinedButton.icon(onPressed:()=>_editRecipe(existing:r),icon:const Icon(Icons.edit),label:const Text('تعديل')),
        OutlinedButton.icon(onPressed:()=>_confirmDelete(r),icon:const Icon(Icons.delete_outline),label:const Text('حذف')),
      ])),
    ]))),
  ]);
  Widget _prices(){
    final names=<String>{}; for(final r in widget.recipes){for(final i in r.ingredients){names.add(i.name);}}
    final sorted=names.toList()..sort();
    return ListView(padding:const EdgeInsets.all(14),children:[
      const Text('أسعار الخامات',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
      const Padding(padding:EdgeInsets.symmetric(vertical:8),child:Text('أدخل سعر شراء الكيلو لكل خامة بالجنيه. تُستخدم الأسعار في تقدير تكلفة التركيبة.')),
      ...sorted.map((n)=>Card(child:ListTile(title:Text(n),subtitle:Text(widget.prices.containsKey(n)?'${widget.prices[n]!.toStringAsFixed(2)} جنيه / كجم':'لم يتم تسجيل سعر'),trailing:IconButton(icon:const Icon(Icons.edit),onPressed:()=>_editPrice(n))))),
    ]);
  }

  double _sum(String kind)=>widget.entries.where((e)=>e.kind==kind).fold(0,(a,e)=>a+e.total);
  Map<String,double> _stock(){
    final m=<String,double>{};
    for(final e in widget.entries){if(e.kind=='شراء')m[e.item]=(m[e.item]??0)+e.quantity;
      if(e.kind=='بيع')m[e.item]=(m[e.item]??0)-e.quantity;}
    return m;
  }
  double get _salesProfitEstimate {
    final purchases=<String,List<double>>{};
    for(final e in widget.entries.where((x)=>x.kind=='شراء')){
      final v=purchases.putIfAbsent(e.item,()=>[0,0]); v[0]+=e.total; v[1]+=e.quantity;
    }
    double cogs=0;
    for(final e in widget.entries.where((x)=>x.kind=='بيع')){
      final v=purchases[e.item]; if(v!=null&&v[1]>0)cogs+=e.quantity*(v[0]/v[1]);
    }
    return _sum('بيع')-cogs-_sum('مصروف');
  }
  Widget _accounts()=>ListView(padding:const EdgeInsets.all(14),children:[
    const Text('إدارة المخزون والحسابات',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
    const SizedBox(height:10),
    Wrap(spacing:8,runSpacing:8,children:[
      _metric('إجمالي المبيعات',_sum('بيع')),
      _metric('إجمالي المشتريات',_sum('شراء')),
      _metric('المصروفات',_sum('مصروف')),
      _metric('ربح تقديري',_salesProfitEstimate),
    ]),
    const SizedBox(height:10),
    Wrap(spacing:8,runSpacing:8,children:[
      _metric('مستحق من العملاء',_customerBalance),
      _metric('مستحق للموردين',_supplierBalance),
      _metric('مبيعات اليوم',_periodSum('بيع',today:true)),
      _metric('مبيعات الشهر',_periodSum('بيع',month:true)),
    ]),
    const SizedBox(height:12),
    Row(children:[const Expanded(child:Text('تسجيل حركة جديدة',style:TextStyle(fontSize:18,fontWeight:FontWeight.bold))),
      FilledButton.icon(onPressed:_addEntry,icon:const Icon(Icons.add),label:const Text('إضافة'))]),
    const SizedBox(height:8),
    const Text('كشف حساب العملاء والموردين',style:TextStyle(fontWeight:FontWeight.bold,fontSize:16)),
    ..._partyStatements(),
    const SizedBox(height:8),
    const Text('المخزون الحالي',style:TextStyle(fontWeight:FontWeight.bold,fontSize:16)),
    ..._stock().entries.where((e)=>e.value.abs()>0.0001).map((e)=>Card(child:ListTile(
      title:Text(e.key),trailing:Text('${e.value.toStringAsFixed(2)} وحدة',style:const TextStyle(fontWeight:FontWeight.bold))))),
    const SizedBox(height:8),
    const Text('سجل الحركات',style:TextStyle(fontWeight:FontWeight.bold,fontSize:16)),
    if(widget.entries.isEmpty) const Padding(padding:EdgeInsets.all(18),child:Text('لا توجد حركات مسجلة بعد')),
    ...widget.entries.reversed.map((e)=>Card(child:ListTile(
      leading:CircleAvatar(child:Icon(e.kind=='بيع'?Icons.point_of_sale:e.kind=='شراء'?Icons.shopping_cart:e.kind=='مصروف'?Icons.money_off:Icons.credit_card)),
      title:Text('${e.kind}${e.item.isEmpty?'':' • ${e.item}'}'),
      subtitle:Text('${e.party.isEmpty?'':e.party+' • '}${e.date.day}/${e.date.month}/${e.date.year}${e.invoiceNo.isEmpty?'':' • فاتورة ${e.invoiceNo}'}${e.note.isEmpty?'':'\\n'+e.note}'),
      isThreeLine:e.note.isNotEmpty,
      trailing:Text('${e.total.toStringAsFixed(2)} ج',style:const TextStyle(fontWeight:FontWeight.bold)),
      onLongPress:()=>_deleteEntry(e),
    ))),
    const Padding(padding:EdgeInsets.only(top:8),child:Text('الربح تقديري حسب متوسط تكلفة الشراء المسجلة للصنف، ولا يشمل رصيد أول المدة أو التالف أو الضرائب أو أي مصروف غير مسجل. الديون والتحصيلات والسداد تظهر في كشف الحساب؛ تسجيل الفاتورة لا يعني أنها محصلة.',style:TextStyle(color:Colors.black54))),
  ]);

  double get _customerBalance => _sum('بيع') + _sum('دين عميل') - _sum('تحصيل عميل');
  double get _supplierBalance => _sum('شراء') + _sum('دين مورد') - _sum('سداد مورد');
  double _periodSum(String kind,{bool today=false,bool month=false}) {
    final now=DateTime.now();
    return widget.entries.where((e) {
      if(e.kind!=kind)return false;
      if(today)return e.date.year==now.year&&e.date.month==now.month&&e.date.day==now.day;
      if(month)return e.date.year==now.year&&e.date.month==now.month;
      return true;
    }).fold(0,(a,e)=>a+e.total);
  }
  List<Widget> _partyStatements() {
    final names=<String>{};
    for(final e in widget.entries){if(e.party.trim().isNotEmpty)names.add(e.party.trim());}
    final widgets=<Widget>[];
    for(final name in names.toList()..sort()){
      final customerSales=widget.entries.where((e)=>e.party==name&&(e.kind=='بيع'||e.kind=='دين عميل')).fold(0.0,(a,e)=>a+e.total);
      final customerPaid=widget.entries.where((e)=>e.party==name&&e.kind=='تحصيل عميل').fold(0.0,(a,e)=>a+e.total);
      final supplierPurchases=widget.entries.where((e)=>e.party==name&&(e.kind=='شراء'||e.kind=='دين مورد')).fold(0.0,(a,e)=>a+e.total);
      final supplierPaid=widget.entries.where((e)=>e.party==name&&e.kind=='سداد مورد').fold(0.0,(a,e)=>a+e.total);
      final dueCustomer=customerSales-customerPaid;
      final dueSupplier=supplierPurchases-supplierPaid;
      if(customerSales>0||customerPaid>0||supplierPurchases>0||supplierPaid>0){
        widgets.add(Card(child:ExpansionTile(title:Text(name),subtitle:Text(
          'رصيد العميل: ${dueCustomer.toStringAsFixed(2)} ج • رصيد المورد: ${dueSupplier.toStringAsFixed(2)} ج'),
          children:[
            ListTile(dense:true,title:const Text('مبيعات / مديونية عميل'),trailing:Text('${customerSales.toStringAsFixed(2)} ج')),
            ListTile(dense:true,title:const Text('التحصيلات'),trailing:Text('${customerPaid.toStringAsFixed(2)} ج')),
            ListTile(dense:true,title:const Text('مشتريات / مديونية مورد'),trailing:Text('${supplierPurchases.toStringAsFixed(2)} ج')),
            ListTile(dense:true,title:const Text('السداد للمورد'),trailing:Text('${supplierPaid.toStringAsFixed(2)} ج')),
          ])));
      }
    }
    return widgets;
  }
  Widget _metric(String title,double value)=>SizedBox(width:MediaQuery.of(context).size.width/2-22,child:Card(child:Padding(padding:const EdgeInsets.all(12),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    Text(title,style:const TextStyle(color:Colors.black54)),const SizedBox(height:5),
    Text('${value.toStringAsFixed(2)} ج',style:const TextStyle(fontSize:17,fontWeight:FontWeight.bold)),
  ]))));
  Future<void> _addEntry() async {
    String kind='شراء'; final item=TextEditingController(),party=TextEditingController(),qtyC=TextEditingController(text:'1'),priceC=TextEditingController(),note=TextEditingController(),invoiceC=TextEditingController();
    DateTime date=DateTime.now();
    final ok=await showDialog<bool>(context:context,builder:(ctx)=>StatefulBuilder(builder:(ctx,sd)=>AlertDialog(
      title:const Text('تسجيل حركة'),
      content:SizedBox(width:480,child:SingleChildScrollView(child:Column(mainAxisSize:MainAxisSize.min,children:[
        DropdownButtonFormField<String>(value:kind,decoration:const InputDecoration(labelText:'نوع الحركة'),items:['شراء','بيع','مصروف','دين عميل','دين مورد','تحصيل عميل','سداد مورد'].map((x)=>DropdownMenuItem(value:x,child:Text(x))).toList(),onChanged:(v)=>sd(()=>kind=v??kind)),
        if(kind=='شراء'||kind=='بيع')TextField(controller:item,decoration:const InputDecoration(labelText:'اسم الصنف')),
        if(kind=='شراء'||kind=='بيع')TextField(controller:invoiceC,decoration:const InputDecoration(labelText:'رقم الفاتورة (اختياري)')),
        TextField(controller:party,decoration:InputDecoration(labelText:kind=='مصروف'?'جهة الصرف / البيان':'العميل أو المورد')),
        if(kind=='شراء'||kind=='بيع')TextField(controller:qtyC,keyboardType:const TextInputType.numberWithOptions(decimal:true),decoration:const InputDecoration(labelText:'الكمية')),
        TextField(controller:priceC,keyboardType:const TextInputType.numberWithOptions(decimal:true),decoration:InputDecoration(labelText:kind=='مصروف'?'قيمة المصروف':(kind=='تحصيل عميل'?'مبلغ التحصيل':(kind=='سداد مورد'?'مبلغ السداد':'سعر الوحدة / قيمة الدين')),suffixText:'جنيه')),
        TextField(controller:note,decoration:const InputDecoration(labelText:'ملاحظات')),
        TextButton.icon(onPressed:()async{final d=await showDatePicker(context:ctx,initialDate:date,firstDate:DateTime(2020),lastDate:DateTime(2100));if(d!=null)sd(()=>date=d);},icon:const Icon(Icons.calendar_month),label:Text('التاريخ: ${date.day}/${date.month}/${date.year}')),
      ]))),
      actions:[TextButton(onPressed:()=>Navigator.pop(ctx,false),child:const Text('إلغاء')),FilledButton(onPressed:()=>Navigator.pop(ctx,true),child:const Text('حفظ'))],
    )));
    if(ok==true){
      final q=(kind=='مصروف'||kind=='دين عميل'||kind=='دين مورد'||kind=='تحصيل عميل'||kind=='سداد مورد')?1.0:double.tryParse(qtyC.text.replaceAll(',','.'));
      final v=double.tryParse(priceC.text.replaceAll(',','.'));
      if(q==null||q<=0||v==null||v<0||((kind=='شراء'||kind=='بيع')&&item.text.trim().isEmpty)){
        if(mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('راجع اسم الصنف والكمية والقيمة المدخلة')));return;
      }
      widget.entries.add(LedgerEntry(id:DateTime.now().microsecondsSinceEpoch.toString(),kind:kind,item:item.text.trim(),party:party.text.trim(),note:note.text.trim(),invoiceNo:invoiceC.text.trim(),quantity:q,unitPrice:v,date:date));
      await refreshSave();
    }
  }
  Future<void> _deleteEntry(LedgerEntry e)async{
    final yes=await showDialog<bool>(context:context,builder:(ctx)=>AlertDialog(title:const Text('حذف الحركة؟'),content:const Text('سيتم حذف الحركة من السجل وتحديث المخزون والإجماليات.'),actions:[
      TextButton(onPressed:()=>Navigator.pop(ctx,false),child:const Text('إلغاء')),FilledButton(onPressed:()=>Navigator.pop(ctx,true),child:const Text('حذف'))]));
    if(yes==true){widget.entries.remove(e);await refreshSave();}
  }
  Future<void> _editPrice(String name)async{
    final c=TextEditingController(text:widget.prices[name]?.toString()??'');
    final ok=await showDialog<bool>(context:context,builder:(ctx)=>AlertDialog(title:Text('سعر $name'),content:TextField(controller:c,keyboardType:const TextInputType.numberWithOptions(decimal:true),decoration:const InputDecoration(labelText:'سعر الكيلو بالجنيه')),actions:[TextButton(onPressed:()=>Navigator.pop(ctx,false),child:const Text('إلغاء')),FilledButton(onPressed:()=>Navigator.pop(ctx,true),child:const Text('حفظ'))]));
    if(ok==true){final v=double.tryParse(c.text.trim().replaceAll(',','.'));if(v!=null&&v>=0){widget.prices[name]=v;await refreshSave();}}
  }
  Future<void> _editRecipe({Recipe? existing})async{
    final name=TextEditingController(text:existing?.name??'');
    final rows=<Map<String,TextEditingController>>[];
    if(existing!=null){for(final i in existing.ingredients){rows.add({'name':TextEditingController(text:i.name),'percent':TextEditingController(text:i.percent?.toString()??''),'note':TextEditingController(text:i.note??'')});}}
    else {rows.add({'name':TextEditingController(),'percent':TextEditingController(),'note':TextEditingController()});}
    await showDialog<void>(context:context,builder:(ctx)=>StatefulBuilder(builder:(ctx,setDialog)=>AlertDialog(
      title:Text(existing==null?'إضافة منتج':'تعديل ${existing.name}'),
      content:SizedBox(width:500,height:MediaQuery.of(ctx).size.height*.62,child:Column(children:[
        TextField(controller:name,decoration:const InputDecoration(labelText:'اسم المنتج')),
        const SizedBox(height:8),Expanded(child:ListView(children:[
          ...List.generate(rows.length,(index){final row=rows[index];return Card(child:Padding(padding:const EdgeInsets.all(8),child:Column(children:[
            TextField(controller:row['name'],decoration:const InputDecoration(labelText:'اسم الخام')),
            Row(children:[Expanded(child:TextField(controller:row['percent'],keyboardType:const TextInputType.numberWithOptions(decimal:true),decoration:const InputDecoration(labelText:'النسبة % (اتركها فارغة للقياس)'))),IconButton(onPressed:()=>setDialog(()=>rows.removeAt(index)),icon:const Icon(Icons.delete_outline))]),
            TextField(controller:row['note'],decoration:const InputDecoration(labelText:'ملاحظة اختيارية')),
          ])));}),
          TextButton.icon(onPressed:()=>setDialog(()=>rows.add({'name':TextEditingController(),'percent':TextEditingController(),'note':TextEditingController()})),icon:const Icon(Icons.add),label:const Text('إضافة خامة')),
        ])),
      ])),
      actions:[TextButton(onPressed:()=>Navigator.pop(ctx),child:const Text('إلغاء')),FilledButton(onPressed:()async{
        final n=name.text.trim(); if(n.isEmpty||rows.isEmpty){return;}
        final ingredients=<Ingredient>[];
        for(final row in rows){final rn=row['name']!.text.trim();if(rn.isEmpty)continue;final ps=row['percent']!.text.trim();final p=ps.isEmpty?null:double.tryParse(ps.replaceAll(',','.'));if(ps.isNotEmpty&&p==null)continue;ingredients.add(Ingredient(rn,p,note:row['note']!.text.trim().isEmpty?null:row['note']!.text.trim()));}
        if(ingredients.isEmpty)return;
        if(existing==null){if(widget.recipes.any((r)=>r.name==n)){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('اسم المنتج موجود بالفعل')));return;}widget.recipes.add(Recipe(n,ingredients));}
        else{existing.name=n;existing.ingredients=ingredients;}
        await refreshSave();if(ctx.mounted)Navigator.pop(ctx);
      },child:const Text('حفظ'))],
    )));
  }
  Future<void> _confirmDelete(Recipe r)async{
    final ok=await showDialog<bool>(context:context,builder:(ctx)=>AlertDialog(title:const Text('حذف التركيبة؟'),content:Text('سيتم حذف ${r.name} من هذا الجهاز.'),actions:[TextButton(onPressed:()=>Navigator.pop(ctx,false),child:const Text('إلغاء')),FilledButton(onPressed:()=>Navigator.pop(ctx,true),child:const Text('حذف'))]));
    if(ok==true){widget.recipes.remove(r);if(widget.recipes.isEmpty){widget.recipes.add(Recipe('منتج جديد',[]));}selected=widget.recipes.first.name;batchKg=null;await refreshSave();}
  }
}