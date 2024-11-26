// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace Microsoft.EServices.EDocumentConnector.Tietoevry;

using System.Telemetry;

page 6392 "Connection Setup Card"
{
    PageType = Card;
    SourceTable = "Connection Setup";
    ApplicationArea = Basic, Suite;
    UsageCategory = None;
    Caption = 'Tietoevry Connection Setup';
    Permissions = tabledata "Connection Setup" = rm;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(ClientID; this.ClientID)
                {
                    Caption = 'Client ID';
                    ToolTip = 'Specifies the client ID.';
                    ApplicationArea = Basic, Suite;
                    ExtendedDatatype = Masked;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        this.TietoevryAuth.SetClientId(Rec."Client ID - Key", this.ClientID);
                    end;
                }
                field(ClientSecret; this.ClientSecret)
                {
                    Caption = 'Client Secret';
                    ToolTip = 'Specifies the client secret.';
                    ApplicationArea = Basic, Suite;
                    ExtendedDatatype = Masked;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        this.TietoevryAuth.SetClientSecret(Rec."Client Secret - Key", this.ClientSecret);
                    end;
                }
                field("Authentication URL"; Rec."Authentication URL")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the URL to connect to Avalara.';
                }
                field("API URL"; Rec."API URL")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the URL to connect to Avalara''s api.';
                }
                field("Sandbox Authentication URL"; Rec."Sandbox Authentication URL")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the URL to connect to Avalara sandbox.';
                }
                field("Sandbox API URL"; Rec."Sandbox API URL")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the URL to connect to Avalara sandbox api.';
                }
                field("Company Id"; Rec."Company Id")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the company ID.';
                }
                field("Send Mode"; Rec."Send Mode")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the send mode.';
                    ShowMandatory = true;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(Authenticate)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Authenticate';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Verify the Authentication Details';

                trigger OnAction()
                var
                    TietoevryAuth: Codeunit Authenticator;
                    [NonDebuggable]
                    Token: SecretText;
                begin
                    Token := TietoevryAuth.GetAccessToken();
                    if not Token.IsEmpty() then
                        Message(this.AuthSuccessMsg)
                    else
                        Error(this.AuthFailedErr);
                end;
            }
        }
    }
    trigger OnOpenPage()
    var
        FeatureTelemetry: Codeunit "Feature Telemetry";
    begin
        FeatureTelemetry.LogUptake('0000NHL', this.TietoevryProcessing.GetTietoevryTok(), Enum::"Feature Uptake Status"::Discovered);
        this.TietoevryAuth.CreateConnectionSetupRecord();
        this.TietoevryAuth.IsClientCredsSet(this.ClientID, this.ClientSecret);
    end;

    trigger OnClosePage()
    begin
        Rec.TestField("Company Id");
        Rec.TestField("Send Mode");
    end;

    var

        TietoevryAuth: Codeunit "Authenticator";
        TietoevryProcessing: Codeunit Processing;
        AuthSuccessMsg: Label 'Authenticated successfully';
        AuthFailedErr: Label 'Authentication failed';
        [NonDebuggable]
        ClientID, ClientSecret : Text;
}
