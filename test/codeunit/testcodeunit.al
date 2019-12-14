codeunit 50140 "Test codeunit - Sandi"
{
    Subtype = Test;
    TestPermissions = Disabled;

    [Test]
    [HandlerFunctions('TravelHandler')]
    procedure TestTravelDocument()
    begin
        Initialize('TO-001');
        PosTravelDoc.Run(TravelDoc);
        VendLedgEntry.FindLast();
        Assert.IsTrue(VendLedgEntry."Travel Cost", 'Travel Order je uspješno proknjižen');
    end;

    [Test]
    procedure TestUI()
    var
        TravelDocPage: TestPage "Travel Document Card";
    begin
        Initialize('TO-002');
        Permission.SetO365BusFull();
        TravelDocPage.OpenView();
        TravelDocPage.GoToKey('TO-002');
        Assert.IsTrue(TravelDocPage."No.".Value = 'TO-002', 'Ne vidimo nalog TO-002 nego vidimo ->' + TravelDocPage."No.".Value);
    end;

    [MessageHandler]
    procedure TravelHandler(Msg: text[1024])
    var
        myInt: Integer;
    begin
        assert.IsTrue((Msg = 'Bravo Perger') OR (Msg = 'bravo1'), 'Tvoj meseđ bi trebao biti:' + Msg);
    end;

    procedure Initialize(DocNo: code[20])
    begin
        TravelDoc.Init();
        TravelDoc."No." := DocNo;
        TravelDoc.VALIDATE("Employee No.", 'AH');
        TravelDoc.insert();

        TravelDocLine.Init();
        TravelDocLine."Document No." := DocNo;
        TravelDocLine."Line No." := 10000;
        TravelDocLine.Destination := 'DALEKO';
        TravelDocLine."Destination Description" := 'Negdje jako daleko';
        TravelDocLine."Start Date Time" := CreateDateTime(20191210D, 070000T);
        TravelDocLine."End Date Time" := CreateDateTime(TODAY, 100000T);
        TravelDocLine."Cost Type" := "Travel Cost Type"::Mileage;
        TravelDocLine.Insert();
    end;


    var
        Assert: Codeunit "Library Assert";
        LibSales: codeunit "Library - Sales";
        Cust: Record Customer;
        CustPostGroup: Record "Customer Posting Group";
        TravelDoc: record "Travel Order Header";
        TravelDocLine: Record "Travel line";
        PosTravelDoc: Codeunit "Post Travel Order";
        VendLedgEntry: Record "Vendor Ledger Entry";
        Permission: codeunit "Library - Lower Permissions";

}