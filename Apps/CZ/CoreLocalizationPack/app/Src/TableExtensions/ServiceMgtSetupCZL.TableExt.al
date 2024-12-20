#if not CLEANSCHEMA25
// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace Microsoft.Service.Setup;

using Microsoft.Finance.VAT.Setup;

tableextension 11716 "Service Mgt. Setup CZL" extends "Service Mgt. Setup"
{
    fields
    {
#pragma warning disable AL0842
        field(11780; "Default VAT Date CZL"; Enum "Default VAT Date CZL")
#pragma warning restore AL0842
        {
            Caption = 'Default VAT Date';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteTag = '25.0';
            ObsoleteReason = 'Replaced by VAT Reporting Date in General Ledger Setup.';
        }
    }
}
#endif