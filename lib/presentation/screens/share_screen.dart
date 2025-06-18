import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_month_year_picker/simple_month_year_picker.dart';
import 'package:task_app/data/utils/travel_items_list.dart';
import 'package:task_app/presentation/widgets/my_search_anchor.dart';
import 'package:task_app/presentation/widgets/rating_star_widget.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen({super.key});

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  double value = 5;
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _travelDateController = TextEditingController();

  final SearchController _departureAirportsSearchController =
      SearchController();
  final SearchController _arrivalAirportsSearchController = SearchController();
  final SearchController _airLineSearchController = SearchController();
  final SearchController _classSearchController = SearchController();

  List<String> sugCity = [];

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _travelDateController.dispose();

    _departureAirportsSearchController.dispose();
    _arrivalAirportsSearchController.dispose();
    _airLineSearchController.dispose();
    _classSearchController.dispose();
  }

  Future<void> _onTapPickImage() async {
    final ImagePicker picker = ImagePicker();

    List<XFile?> images = await picker.pickMultiImage();

    for (var img in images) {
      debugPrint("${img?.path}");
    }
  }

  Future<void> _onTapTravelDate() async {
    final DateTime dateTime =
        await SimpleMonthYearPicker.showMonthYearPickerDialog(
          context: context,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,

        );

    _travelDateController.text = dateTime.month.toString().length == 1
        ? "0${dateTime.month} - ${dateTime.year}"
        : "${dateTime.month} - ${dateTime.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Share")),
      body: Container(
        margin: EdgeInsets.all(12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(2, 5),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            spacing: 16,
            children: [_imagePicker(), _textFields(), _lowerPart()],
          ),
        ),
      ),
    );
  }

  Widget _imagePicker() {
    return GestureDetector(
      onTap: _onTapPickImage,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        height: 120,
        width: double.infinity,
        child: DottedBorder(
          options: RoundedRectDottedBorderOptions(
            radius: Radius.circular(16),
            dashPattern: [10, 5],
            strokeWidth: 2,
            padding: EdgeInsets.all(16),
            color: Colors.grey,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_outlined, size: 52),
                Text(
                  "Pick Your Image Here",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textFields() {
    return Column(
      spacing: 12,
      children: [
        MySearchAnchor(
          hintText: "Departure Airport",
          searchController: _departureAirportsSearchController,
          itemList: TravelItemsLists.airports,
        ),
        MySearchAnchor(
          hintText: "Arrival Airport",
          searchController: _arrivalAirportsSearchController,
          itemList: TravelItemsLists.airports,
        ),
        MySearchAnchor(
          hintText: "Airline",
          searchController: _airLineSearchController,
          itemList: TravelItemsLists.airports,
        ),
        MySearchAnchor(
          hintText: "Class",
          searchController: _classSearchController,
          itemList: TravelItemsLists.airports,
        ),
        TextField(
          controller: _messageController,
          maxLines: 5,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(25),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(25),
            ),
            hintText: "Write Your Message",
            filled: true,
            fillColor: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      ],
    );
  }

  Widget _lowerPart() {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 140,
              child: TextField(
                onTap: _onTapTravelDate,
                controller: _travelDateController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "Travel Date",
                  suffixIcon: Card(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Icon(Icons.calendar_month),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Text("Rating", style: TextStyle(fontSize: 16)),
                RatingStarWidget(iconSize: 20,),
                SizedBox(width: 4),
              ],
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            alignment: Alignment.center,
            minimumSize: Size(100, 50),
          ),
          child: Text("Submit"),
        ),
      ],
    );
  }
}
