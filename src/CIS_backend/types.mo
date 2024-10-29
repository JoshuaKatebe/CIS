import Principal "mo:base/Principal";
import Time "mo:base/Time";

module {
    // Authentication and User Types
    public type AuthMethod = {
        #EmailPassword;
        #InternetIdentity;
    };

    public type Role = {
        #Administrator;
        #Investigator;
        #Supervisor;
        #Analyst;
        #TechnicalSupport;
    };

    public type UserStatus = {
        #Active;
        #Suspended;
        #Inactive;
    };

    public type User = {
        var id: Principal;
        var email: Text;
        var password: ?Text;  // Optional for II users
        var name: Text;
        var badge: Text;
        var department: Text;
        var role: Role;
        var status: UserStatus;
        var lastLogin: Time.Time;
        authMethod: AuthMethod;
        created: Time.Time;
        var biometricEnabled: Bool;
    };

    // Case Management Types
    public type CaseStatus = {
        #New;
        #Active;
        #Pending;
        #Closed;
        #Archived;
    };

    public type CasePriority = {
        #High;
        #Medium;
        #Low;
    };

    public type Case = {
        id: Text;
        var title: Text;
        var description: Text;
        var status: CaseStatus;
        var priority: CasePriority;
        created: Time.Time;
        createdBy: Principal;
        var assignedTo: [Principal];
        var lastUpdated: Time.Time;
        var location: ?Location;
        var tags: [Text];
    };

    // Evidence Types
    public type EvidenceType = {
        #Document;
        #Photo;
        #Video;
        #Audio;
        #Physical;
        #Digital;
        #Other;
    };

    public type EvidenceStatus = {
        #Collected;
        #Processing;
        #Analyzed;
        #Stored;
        #Released;
    };

    public type Evidence = {
        id: Text;
        caseId: Text;
        var description: Text;
        evidenceType: EvidenceType;
        var status: EvidenceStatus;
        collectedBy: Principal;
        collectedAt: Time.Time;
        var location: Text;  // Storage location
        var chain: [CustodyEntry];
        var tags: [Text];
        var notes: [Note];
        metadata: EvidenceMetadata;
    };

    public type EvidenceMetadata = {
        fileHash: ?Text;
        fileSize: ?Nat;
        fileType: ?Text;
        dimensions: ?Text;
        duration: ?Nat;
        originalFilename: ?Text;
        deviceInfo: ?Text;
    };

    // Chain of Custody
    public type CustodyEntry = {
        id: Text;
        evidenceId: Text;
        fromPrincipal: Principal;
        toPrincipal: Principal;
        timestamp: Time.Time;
        reason: Text;
        var notes: ?Text;
    };

    // Communication Types
    public type MessageStatus = {
        #Sent;
        #Delivered;
        #Read;
    };

    public type Message = {
        id: Text;
        fromPrincipal: Principal;
        toPrincipal: Principal;
        content: Text;
        timestamp: Time.Time;
        var status: MessageStatus;
        caseId: ?Text;
        isUrgent: Bool;
    };

    // Location Types
    public type Location = {
        latitude: Float;
        longitude: Float;
        address: ?Text;
        description: ?Text;
        timestamp: Time.Time;
    };

    // Note Types
    public type Note = {
        id: Text;
        content: Text;
        createdBy: Principal;
        timestamp: Time.Time;
        var editedAt: ?Time.Time;
        var attachments: [Text];
    };

    // Audit Types
    public type ActionType = {
        #Create;
        #Read;
        #Update;
        #Delete;
        #Access;
        #Export;
    };

    public type AuditEntry = {
        id: Text;
        timestamp: Time.Time;
        principal: Principal;
        actionType: ActionType;
        resourceType: Text;
        resourceId: Text;
        details: Text;
        ipAddress: ?Text;
        success: Bool;
    };

    // Emergency Types
    public type EmergencyAlert = {
        id: Text;
        officerId: Principal;
        timestamp: Time.Time;
        location: Location;
        var status: EmergencyStatus;
        var respondingUnits: [Principal];
        var notes: [Note];
    };

    public type EmergencyStatus = {
        #Active;
        #Responding;
        #Resolved;
        #FalseAlarm;
    };

    // Analytics Types
    public type ReportType = {
        #CaseStatus;
        #EvidenceAnalysis;
        #OfficerActivity;
        #DepartmentMetrics;
        #Custom;
    };

    public type Report = {
        id: Text;
        reportType: ReportType;
        createdBy: Principal;
        timestamp: Time.Time;
        parameters: [(Text, Text)];
        var data: [(Text, Text)];
        var status: ReportStatus;
    };

    public type ReportStatus = {
        #Generating;
        #Complete;
        #Error;
    };

    // Response Types for APIs
    public type Result<Ok, Err> = {
        #ok: Ok;
        #err: Err;
    };

    public type Response<T> = Result<T, Text>;
};