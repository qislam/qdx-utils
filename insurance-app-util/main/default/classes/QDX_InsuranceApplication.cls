public with sharing class QDX_InsuranceApplication {
    public Id applicationId {get; set;}
    public Id productBundleId {get; set;}
    public QDX_InsuranceCoverage[] coverages {get; set;}

    public QDX_InsuranceApplication(Id applicationId) {
        this.applicationId = applicationId;
    }
}