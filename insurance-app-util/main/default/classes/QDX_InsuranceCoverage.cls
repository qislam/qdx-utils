public with sharing class QDX_InsuranceCoverage {
    public Id coverageConfigId {get; set;}
    public String coverageName {get; set;}
    public String coverageType {get; set;}
    public String coverageDescription {get; set;}
    public Integer coverageLimitMin {get; set;}
    public Integer coverageLimitMax {get; set;}
    public Boolean isRequired {get; set;}
    public QDX_InsuranceAttribute[] attributes {get; set;}

    public QDX_InsuranceCoverage(Id coverageConfigId) {
        this.coverageConfigId = coverageConfigId;
    }
}