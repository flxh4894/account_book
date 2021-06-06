import 'package:accountbook/src/controller/search_controller.dart';
import 'package:accountbook/src/model/asset_content.dart';
import 'package:accountbook/src/model/daily_cost.dart';
import 'package:accountbook/src/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../edit_cost.dart';

class CalendarSearchPage extends StatefulWidget {
  @override
  _CalendarSearchPageState createState() => _CalendarSearchPageState();
}

class _CalendarSearchPageState extends State<CalendarSearchPage> {
  final TextEditingController _textWord = TextEditingController();
  final CommonUtils _utils = CommonUtils();

  final SearchController _searchController = Get.put(SearchController());

  String _displayOption(AssetContent option) => option.title;

  // 삭제 후 콜백 처리
  void deleteCallback(DailyCost dailyCost) {
    _searchController.dailyCostList.remove(dailyCost);

    if(_searchController.dailyCostList.length == 0){
      _searchController.getAllAccountBook();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: _body(),
    );
  }

  Container _body() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Container(
            child: Autocomplete(
              displayStringForOption: (AssetContent option) => option.title,

              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<AssetContent>.empty();
                }
                return _searchController.assetContentList.where((AssetContent option) {
                  return option.title.contains(textEditingValue.text.toLowerCase());
                });
              },

              onSelected: (AssetContent selected) {
                _searchController.getContentsFromTitle(selected.title);
                FocusScope.of(context).requestFocus(FocusNode()); // 온스크린 키보드 해제
              },

              fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                return TextFormField(
                  focusNode: focusNode,
                  controller: textEditingController,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: '검색어를 입력해 주세요.',
                    prefixIcon: Icon(Icons.search),
                    isDense: true,
                    border: OutlineInputBorder()
                  ),
                );
              },

              optionsViewBuilder: (context, Function onSelected, Iterable<AssetContent> options) {
                final List<AssetContent> list = options.map((e) => e).toList();
                return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 5.0,
                      child: Container(
                          width: MediaQuery.of(context).size.width-32,
                          child: ListView.separated(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(10),
                            itemCount: options.length,
                            separatorBuilder: (context, i) {
                              return Divider();
                            },
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  onSelected(list[index]);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Text(list[index].title),
                                ),
                              );
                            },
                          )
                      ),
                    )
                );
              },
            )
          ),
          SizedBox(height: 30),
          Obx(
            () {
              var list = _searchController.dailyCostList;
              return Expanded(
                child: ListView.separated(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final content = list[index];

                    var color = Colors.red;
                    if(content.type == 2)
                      color = Colors.blue;
                    else if(content.type == 3)
                      color = Colors.green;

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Theme.of(context).primaryColor.withOpacity(0.2),
                        onTap: () {
                          Get.to(() => EditCostPage(), arguments: {'content': content, 'callBack': deleteCallback});
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text('${content.date.substring(0,4)}'
                                      '.${content.date.substring(4,6)}'
                                      '.${content.date.substring(6,8)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black.withOpacity(0.5)
                                    )
                                  ),
                                  Container(
                                      width: 80,
                                      child: Text(content.category,
                                          style: TextStyle(color: Colors.black.withOpacity(0.5))
                                      )
                                  ),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                              SizedBox(width: 30),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(content.title, overflow: TextOverflow.ellipsis),
                                    Text('${content.date.substring(8,10)}:${content.date.substring(10,12)} ${content.assetNm}',
                                        style: TextStyle(
                                            color: Colors.black.withOpacity(0.5), fontSize: 12)
                                    ),
                                  ],
                                ),
                              ),
                              Text('${_utils.priceFormat(content.price)}',
                                  style: TextStyle(
                                      color: color
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                ),
              );
            }
          )
        ],
      ),
    );
  }

  TextStyle _appbarTitle() {
    return TextStyle(
      fontSize: 18,
    );
  }

  AppBar _appbar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text('검색', style: _appbarTitle()),
    );
  }
}
