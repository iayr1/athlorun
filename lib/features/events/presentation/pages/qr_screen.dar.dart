import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:athlorun/config/styles/app_colors.dart';
import 'package:athlorun/config/styles/app_textstyles.dart';
import 'package:athlorun/core/utils/windows.dart';
import 'package:athlorun/core/widgets/custom_action_button.dart';
import 'package:athlorun/features/events/presentation/widgets/download_pdf_widget.dart';
import 'package:styled_divider/styled_divider.dart';

class QRTicketScreen extends StatefulWidget {
  @override
  _QRTicketScreenState createState() => _QRTicketScreenState();
}

class _QRTicketScreenState extends State<QRTicketScreen> {
  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> tickets = [
    {
      "id": "E123456789",
      "name": "Poonam Sharma",
      "age": 27,
      "gender": "Female",
      "amount": 499.00,
      "date": "25 Mar 2025",
      "venue": "Mumbai Stadium",
      "seat": "A12"
    },
    {
      "id": "E123456790",
      "name": "Rahul Sharma",
      "age": 30,
      "gender": "Male",
      "amount": 499.00,
      "date": "25 Mar 2025",
      "venue": "Mumbai Stadium",
      "seat": "A13"
    },
    {
      "id": "E123456791",
      "name": "Anjali Verma",
      "age": 25,
      "gender": "Female",
      "amount": 499.00,
      "date": "25 Mar 2025",
      "venue": "Mumbai Stadium",
      "seat": "A14"
    },
    {
      "id": "E123456792",
      "name": "Amit Singh",
      "age": 29,
      "gender": "Male",
      "amount": 499.00,
      "date": "25 Mar 2025",
      "venue": "Mumbai Stadium",
      "seat": "A15"
    },
  ];

  final List<Color> ticketColors = [
    AppColors.primaryBlue30,
    AppColors.secondaryPurple30,
    AppColors.secondaryGreen30,
    AppColors.primaryBlue40,
  ];

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    Window().adaptDeviceScreenSize(view: View.of(context));
    return Scaffold(
      backgroundColor: AppColors.neutral10,
      appBar: AppBar(
        title: Text('Event Tickets',
            style: AppTextStyles.subtitleBold.copyWith(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: AppColors.neutral10,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => setState(() => currentPage = index),
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Window.getHorizontalSize(20),
                      vertical: Window.getVerticalSize(20)),
                  child: ClipPath(
                    clipper: ClipWidget(holeRadius: 40, bottom: 320),
                    child: Container(
                      padding: Window.getPadding(all: 20),
                      decoration: BoxDecoration(
                        color: ticketColors[index % ticketColors.length],
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.black, width: 0.05),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 250,
                            height: 250,
                            child: PrettyQrView.data(
                              data: "TicketID: ${ticket['id']}",
                              decoration: PrettyQrDecoration(
                                shape: PrettyQrSmoothSymbol(
                                  color: AppColors.neutral100,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: Window.getVerticalSize(20)),
                          StyledDivider(
                            color: AppColors.neutral100,
                            height: 50,
                            thickness: 2,
                            lineStyle: DividerLineStyle.dashed,
                            indent: 20,
                            endIndent: 20,
                          ),
                          SizedBox(height: Window.getVerticalSize(10)),
                          _buildTicketDetail("Name", ticket['name']),
                          _buildTicketDetail("Age", ticket['age'].toString()),
                          _buildTicketDetail("Gender", ticket['gender']),
                          _buildTicketDetail("Date", ticket['date']),
                          _buildTicketDetail("Venue", ticket['venue']),
                          _buildTicketDetail("Seat", ticket['seat']),
                          _buildTicketDetail("Price",
                              "₹${ticket['amount'].toStringAsFixed(2)}"),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Text(
            "Page ${currentPage + 1} of ${tickets.length}",
            style: AppTextStyles.bodyMedium,
          ),
          SafeArea(
            child: Padding(
              padding: Window.getSymmetricPadding(vertical: 10, horizontal: 20),
              child: CustomActionButton(
                name: 'Download Ticket',
                isFormFilled: true,
                onTap: (startLoading, stopLoading, state) async {
                  startLoading();
                  await DownloadPdfWidget.downloadPdf(tickets);
                  stopLoading();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketDetail(String title, String detail) => Padding(
        padding: EdgeInsets.symmetric(vertical: Window.getVerticalSize(2)),
        child: RichText(
          textAlign: TextAlign.left,
          text: TextSpan(children: [
            TextSpan(
                text: "$title: ",
                style: AppTextStyles.bodyBold
                    .copyWith(color: AppColors.neutral100)),
            TextSpan(
                text: detail,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.neutral100)),
          ]),
        ),
      );
}

class ClipWidget extends CustomClipper<Path> {
  final double holeRadius;
  final double bottom;

  ClipWidget({required this.holeRadius, required this.bottom});

  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0.0, size.height - bottom - holeRadius)
      ..arcToPoint(
        Offset(0, size.height - bottom),
        clockwise: true,
        radius: const Radius.circular(1),
      )
      ..lineTo(0.0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, size.height - bottom)
      ..arcToPoint(
        Offset(size.width, size.height - bottom - holeRadius),
        clockwise: true,
        radius: const Radius.circular(1),
      );

    path.lineTo(size.width, 0.0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(ClipWidget oldClipper) => true;
}
