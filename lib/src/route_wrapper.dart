import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'address_form.dart';
import 'model/location.dart';
import 'model/prediction.dart';
import 'places_service.dart';

class AddressPickerRouteWrapper extends StatefulWidget {
  const AddressPickerRouteWrapper(
      {super.key,
      required this.anim,
      required this.child,
      required this.addressController,
      required this.cityController,
      required this.zipController,
      required this.mainKey,
      required this.apiKey,
      required this.setModal});

  final Widget child;
  final Animation<double> anim;
  final TextEditingController addressController;
  final TextEditingController zipController;
  final TextEditingController cityController;
  final GlobalKey<AddressFormState> mainKey;
  final Function(bool) setModal;
  final String apiKey;

  @override
  State<AddressPickerRouteWrapper> createState() =>
      _AddressPickerRouteWrapperState();
}

class _AddressPickerRouteWrapperState extends State<AddressPickerRouteWrapper> {
  final uuid = const Uuid();
  late PlacesService _service;

  List<Prediction> predictions = [];

  void setPs(List<Prediction> ps) {
    if (!mounted) return;
    setState(() {
      predictions = ps;
    });
  }

  @override
  void initState() {
    final id = uuid.v4();
    _service = PlacesService(sessionId: id, apiKey: widget.apiKey);

    widget.addressController.addListener(() {
      if (!mounted) return;
      _service
          .fetchPredictions(widget.addressController.text)
          .then((value) => setPs(value));
    });

    super.initState();
  }

  @override
  void dispose() {
    widget.addressController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
            onTap: () {
              widget.setModal(false);
              Navigator.of(context).pop();
            },
            child: Container(
                padding: const EdgeInsets.all(30),
                color: Colors.black.withOpacity(0.5),
                child: SafeArea(
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          children: [
                            Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16))),
                                padding: const EdgeInsets.all(10),
                                child:
                                    Hero(tag: "street", child: widget.child)),
                            Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(16),
                                        bottomRight: Radius.circular(16))),
                                child: Wrap(
                                  children: [
                                    ...predictions.map(
                                      (e) => ListTile(
                                        onTap: () async {
                                          final result = await _service
                                              .fetchDetails(e.placeId);

                                          String? zip = (result
                                                      ?.addressComponents ??
                                                  [])
                                              .firstWhereOrNull((element) =>
                                                  (element.types ?? [])
                                                      .contains("postal_code"))
                                              ?.longName;
                                          String? city =
                                              (result?.addressComponents ?? [])
                                                  .firstWhereOrNull((element) =>
                                                      (element.types ?? [])
                                                          .contains("locality"))
                                                  ?.longName;
                                          String? streetAddress =
                                              (result?.addressComponents ?? [])
                                                  .firstWhereOrNull((element) =>
                                                      (element.types ?? [])
                                                          .contains(
                                                              "street_address"))
                                                  ?.longName;
                                          streetAddress ??=
                                              (result?.addressComponents ?? [])
                                                  .firstWhereOrNull((element) =>
                                                      (element.types ?? [])
                                                          .contains("route"))
                                                  ?.longName;
                                          String? streetNumber =
                                              (result?.addressComponents ?? [])
                                                  .firstWhereOrNull((element) =>
                                                      (element.types ?? [])
                                                          .contains(
                                                              "street_number"))
                                                  ?.longName;

                                          widget.mainKey.currentState
                                              ?.setState(() {
                                            if (result?.geometry?.location !=
                                                null) {
                                              widget.mainKey.currentState!
                                                      .location =
                                                  Location(
                                                      lat: result!.geometry!
                                                          .location!.lat!,
                                                      lng: result.geometry!
                                                          .location!.lng!);
                                            }

                                            if (zip != null) {
                                              widget.zipController.text = zip;
                                            }
                                            if (city != null) {
                                              widget.cityController.text = city;
                                            }
                                            if (streetAddress != null) {
                                              final string =
                                                  "$streetAddress ${streetNumber ?? ""}"
                                                      .trim();
                                              widget.addressController.text =
                                                  string;
                                              widget.addressController
                                                      .selection =
                                                  TextSelection.collapsed(
                                                      offset: string.length);
                                            }
                                            widget.mainKey.currentState
                                                ?.modalOpen = false;
                                          });
                                          if (!mounted) return;
                                          Navigator.of(context).pop();
                                        },
                                        title: Text(e.description),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Spacer(),
                                        Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Image.asset(
                                              'assets/google_white.png',
                                              package: 'address_form',
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                            ))
                                      ],
                                    )
                                  ],
                                )),
                            Expanded(
                              child: Container(color: Colors.transparent),
                            )
                          ],
                        ))))));
  }
}
