import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_month_year_picker/simple_month_year_picker.dart';
import 'package:task_app/data/utils/travel_items_list.dart';
import 'package:task_app/presentation/widgets/my_search_anchor.dart';
import 'package:task_app/service/supabase_post_service.dart';

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

  List<XFile?> _images = [];
  int _currentRate = 0;
  bool _inProgress = false;

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
    _images.clear();

    final ImagePicker picker = ImagePicker();

    _images = await picker.pickMultiImage();

    for (XFile? img in _images) {
      if (img != null) {
        var size = await img.length() / (1024 * 1024);
        debugPrint("Name: ${img.name} Size: ${size.toStringAsFixed(2)}");
      }
    }

    setState(() {});
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

  Future<void> _onTapSubmit() async {
    if (_departureAirportsSearchController.text.isEmpty &&
        _arrivalAirportsSearchController.text.isEmpty &&
        _airLineSearchController.text.isEmpty &&
        _classSearchController.text.isEmpty &&
        _messageController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You have to choose all options")),
        );
        return;
      }
    }

    _inProgress = true;
    setState(() {});
    final supabaseModel = await SupabasePostService.post(
      captions: _messageController.text,
      departureAirport: _departureAirportsSearchController.text,
      arrivalAirport: _arrivalAirportsSearchController.text,
      airline: _airLineSearchController.text,
      classAirline: _classSearchController.text,
      travelDate: _travelDateController.text,
      ratings: _currentRate,
      images: _images,
    );
    _inProgress = false;
    setState(() {});

    if (supabaseModel.isSuccessful) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(supabaseModel.message)));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(supabaseModel.message)));
      }
    }
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
            child: _images.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_outlined, size: 52),
                      Text(
                        "Pick Your Image Here",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      return Text(
                        _images[index]?.name ?? '',
                        style: TextStyle(fontSize: 16),
                      );
                    },
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
          itemList: TravelItemsLists.departureArrivalAirports,
        ),
        MySearchAnchor(
          hintText: "Arrival Airport",
          searchController: _arrivalAirportsSearchController,
          itemList: TravelItemsLists.departureArrivalAirports,
        ),
        MySearchAnchor(
          hintText: "Airline",
          searchController: _airLineSearchController,
          itemList: TravelItemsLists.airlines,
        ),
        MySearchAnchor(
          hintText: "Class",
          searchController: _classSearchController,
          itemList: TravelItemsLists.classAirline,
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
            hintStyle: TextStyle(color: Colors.grey.shade700),
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
                Row(
                  spacing: 2,
                  children: [
                    for (int i = 4; i >= 0; i--)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentRate = i;
                          });
                        },
                        child: Icon(
                          _currentRate <= i ? Icons.star : Icons.star_outline,
                          color: Colors.yellow,
                          size: 24,
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 4),
              ],
            ),
          ],
        ),
        Visibility(
          visible: !_inProgress,
          replacement: CircularProgressIndicator(),
          child: ElevatedButton(
            onPressed: _onTapSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              alignment: Alignment.center,
              minimumSize: Size(100, 50),
            ),
            child: Text("Submit"),
          ),
        ),
      ],
    );
  }
}
