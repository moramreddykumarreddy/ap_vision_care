// lib/data/models/models.dart

enum SpectacleStatus {
  prescriptionApproved,
  vendorAssigned,
  manufacturing,
  qualityCheck,
  dispatched,
  delivered,
}

class PatientModel {
  final String id;
  final String name;
  final String nameTelugu;
  final String mobile;
  final String abhaNumber;
  final int age;
  final String gender;
  final String address;
  final String district;
  final String mandal;
  final String village;
  final String photoUrl;
  final String education;
  final String occupation;
  final String incomeCategory;
  final String socialCategory;
  final String areaType;

  PatientModel({
    required this.id,
    required this.name,
    required this.nameTelugu,
    required this.mobile,
    required this.abhaNumber,
    required this.age,
    required this.gender,
    required this.address,
    required this.district,
    required this.mandal,
    required this.village,
    required this.photoUrl,
    required this.education,
    required this.occupation,
    required this.incomeCategory,
    required this.socialCategory,
    required this.areaType,
  });
}

class PrescriptionModel {
  final String id;
  final String patientId;
  final String patientName;
  final String date;
  final String doctorName;
  final String diagnosis;
  final String rightEyeSph;
  final String rightEyeCyl;
  final String rightEyeAxis;
  final String leftEyeSph;
  final String leftEyeCyl;
  final String leftEyeAxis;
  final String status;
  final SpectacleStatus spectacleStatus;

  PrescriptionModel({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.date,
    required this.doctorName,
    required this.diagnosis,
    required this.rightEyeSph,
    required this.rightEyeCyl,
    required this.rightEyeAxis,
    required this.leftEyeSph,
    required this.leftEyeCyl,
    required this.leftEyeAxis,
    required this.status,
    required this.spectacleStatus,
  });
}

class ReferralModel {
  final String id;
  final String patientName;
  final String patientId;
  final String hospital;
  final String condition;
  final String priority;
  final String status;
  final String date;
  final String doctorName;

  ReferralModel({
    required this.id,
    required this.patientName,
    required this.patientId,
    required this.hospital,
    required this.condition,
    required this.priority,
    required this.status,
    required this.date,
    required this.doctorName,
  });
}

class CampModel {
  final String id;
  final String name;
  final String district;
  final String mandal;
  final String village;
  final String date;
  final String status;
  final int totalRegistered;
  final int totalScreened;
  final int prescriptionsGenerated;
  final int referrals;
  final String teamLead;

  CampModel({
    required this.id,
    required this.name,
    required this.district,
    required this.mandal,
    required this.village,
    required this.date,
    required this.status,
    required this.totalRegistered,
    required this.totalScreened,
    required this.prescriptionsGenerated,
    required this.referrals,
    required this.teamLead,
  });
}

class AnalyticsStateData {
  final int totalPatients;
  final int totalScreened;
  final int totalPrescriptions;
  final int totalReferrals;
  final int teleconsultations;
  final int spectaclesDelivered;
  final List<MonthlyMetric> monthlyData;
  final List<DiseaseData> diseaseDistribution;

  AnalyticsStateData({
    required this.totalPatients,
    required this.totalScreened,
    required this.totalPrescriptions,
    required this.totalReferrals,
    required this.teleconsultations,
    required this.spectaclesDelivered,
    required this.monthlyData,
    required this.diseaseDistribution,
  });
}

class MonthlyMetric {
  final String month;
  final int patients;
  final int screened;
  final int referrals;

  MonthlyMetric({
    required this.month,
    required this.patients,
    required this.screened,
    required this.referrals,
  });
}

class DiseaseData {
  final String disease;
  final int count;
  final double percentage;

  DiseaseData({
    required this.disease,
    required this.count,
    required this.percentage,
  });
}

class DistrictData {
  final String name;
  final int patients;
  final int screened;
  final double coverage;
  final int rank;

  DistrictData({
    required this.name,
    required this.patients,
    required this.screened,
    required this.coverage,
    required this.rank,
  });
}

class TeleconsultationModel {
  final String id;
  final String patientName;
  final String patientId;
  final String doctorName;
  final String scheduledTime;
  final String status;
  final String condition;
  final int duration;

  TeleconsultationModel({
    required this.id,
    required this.patientName,
    required this.patientId,
    required this.doctorName,
    required this.scheduledTime,
    required this.status,
    required this.condition,
    required this.duration,
  });
}

class VendorOrderModel {
  final String id;
  final String patientName;
  final String prescriptionId;
  final String vendorName;
  final String status;
  final String orderDate;
  final String deliveryDate;
  final String lensType;
  final String frameType;
  final double amount;

  VendorOrderModel({
    required this.id,
    required this.patientName,
    required this.prescriptionId,
    required this.vendorName,
    required this.status,
    required this.orderDate,
    required this.deliveryDate,
    required this.lensType,
    required this.frameType,
    required this.amount,
  });
}

class AiRiskData {
  final double catarackRisk;
  final double glaucomaRisk;
  final double diabeticRetinopathyRisk;
  final double blindnessRisk;
  final int highRiskPatients;
  final int totalAnalyzed;

  AiRiskData({
    required this.catarackRisk,
    required this.glaucomaRisk,
    required this.diabeticRetinopathyRisk,
    required this.blindnessRisk,
    required this.highRiskPatients,
    required this.totalAnalyzed,
  });
}

class SchoolVisionData {
  final int totalStudentsScreened;
  final int needingGlasses;
  final int glassesDelivered;
  final int pendingDelivery;
  final List<SchoolData> schools;

  SchoolVisionData({
    required this.totalStudentsScreened,
    required this.needingGlasses,
    required this.glassesDelivered,
    required this.pendingDelivery,
    required this.schools,
  });
}

class SchoolData {
  final String name;
  final int studentsScreened;
  final int needingGlasses;

  SchoolData({
    required this.name,
    required this.studentsScreened,
    required this.needingGlasses,
  });
}

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String time;
  final bool isRead;
  final String type;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.type,
  });
}
