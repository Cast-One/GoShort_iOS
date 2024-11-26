//
//  LocalizableConstants.swift
//  GoShortApp
//
//  Created by Uriel C on 24/11/24.
//

import Foundation

class LocalizableConstants {
    struct General {
        static let nameApp = NSLocalizedString("ShortCut", comment: "")
    }
    
    struct Labels {
        static let titleLabelFree = NSLocalizedString("titleLabelFree", comment: "")
        static let titleLabelPreimum = NSLocalizedString("titleLabelPreimum", comment: "")
        static let urlHeaderText = NSLocalizedString("urlHeaderText", comment: "")
        static let urlPlaceholder = NSLocalizedString("urlPlaceholder", comment: "")
        static let titleCustomURL = NSLocalizedString("titleCustomURL", comment: "Title for the Custom URL screen")
        static let headerLargeURL = NSLocalizedString("headerLargeURL", comment: "Header for the Large URL field")
        static let headerCustomName = NSLocalizedString("headerCustomName", comment: "Header for the Custom Name field")
        static let headerDomainSelected = NSLocalizedString("headerDomainSelected", comment: "Header for the Domain Selected section")
    }
    
    struct Buttons {
        static let shortenButtonTitle = NSLocalizedString("shortenButtonTitle", comment: "")
        static let customButtonTitle = NSLocalizedString("customButtonTitle", comment: "")
        static let premiumButtonTitle = NSLocalizedString("premiumButtonTitle", comment: "")
        static let backButtonTitle = NSLocalizedString("backButtonTitle", comment: "Title for the back button")
        static let generateButtonTitle = NSLocalizedString("generateButtonTitle", comment: "Title for the generate button")
    }
    
    struct SegmentedControl {
        static let shortcuts = NSLocalizedString("segmentedControlShortcuts", comment: "")
        static let customShortcuts = NSLocalizedString("segmentedControlCustomShortcuts", comment: "")
    }
    
    struct Placeholders {
        static let emptyListMessage = NSLocalizedString("emptyListMessage", comment: "")
        static let largeURL = NSLocalizedString("placeholderLargeURL", comment: "Placeholder for the Large URL field")
        static let customName = NSLocalizedString("placeholderCustomName", comment: "Placeholder for the Custom Name field")
        static let domainPicker = NSLocalizedString("placeholderDomainPicker", comment: "Placeholder for the domain picker field")
        static let domainSuffix = NSLocalizedString("placeholderDomainSuffix", comment: "Placeholder for the domain suffix field")
    }
    
    struct Toast {
        static let enterURL = NSLocalizedString("toast.enterURL", comment: "")
        static let textCopied = NSLocalizedString("toast.textCopied", comment: "")
        static let urlShortened = NSLocalizedString("toast.urlShortened", comment: "")
        static let invalidURL = NSLocalizedString("toast.invalidURL", comment: "")
        static let shortCutDeleted = NSLocalizedString("toast.shortCutDeleted", comment: "")
    }
    
    struct Premium {
        static let title = NSLocalizedString("Premium_Title", comment: "")
        static let featuresIntro = NSLocalizedString("Premium_Features_Intro", comment: "")
        static let featureLimitlessLinks = NSLocalizedString("Premium_Feature_Limitless_Links", comment: "")
        static let featureCustomizeLinks = NSLocalizedString("Premium_Feature_Customize_Links", comment: "")
        static let featureTrafficStats = NSLocalizedString("Premium_Feature_Traffic_Stats", comment: "")
        static let featureSecureLinks = NSLocalizedString("Premium_Feature_Secure_Links", comment: "")
        static let featureExpiration = NSLocalizedString("Premium_Feature_Expiration", comment: "")
        static let featureAdFree = NSLocalizedString("Premium_Feature_Ad_Free", comment: "")
        static let featurePrioritySupport = NSLocalizedString("Premium_Feature_Priority_Support", comment: "")
        static let priceText = NSLocalizedString("Premium_Price_Text", comment: "")
        static let priceValue = NSLocalizedString("Premium_Price_Value", comment: "")
        static let priceMonthly = NSLocalizedString("Premium_Price_Monthly", comment: "")
        static let subscribeButton = NSLocalizedString("Premium_Subscribe_Button", comment: "")
        static let terms = NSLocalizedString("Premium_Terms", comment: "")
    }
    
    struct Validation {
        static let invalidURL = NSLocalizedString("validationInvalidURL", comment: "Message for invalid URL")
        static let emptyCustomName = NSLocalizedString("validationEmptyCustomName", comment: "Message for empty Custom Name field")
        static let invalidDomainSuffix = NSLocalizedString("validationInvalidDomainSuffix", comment: "Message for invalid Domain Suffix")
    }

    struct Success {
        static let urlGenerated = NSLocalizedString("successURLGenerated", comment: "Message for successfully generated URL")
    }
    
    struct PremiumLimit {
        static let alertTitle = NSLocalizedString("PremiumLimit.Alert.Title", comment: "")
        static let alertMessage = NSLocalizedString("PremiumLimit.Alert.Message", comment: "")
        static let becomePremium = NSLocalizedString("PremiumLimit.Alert.BecomePremium", comment: "")
        static let cancel = NSLocalizedString("PremiumLimit.Alert.Cancel", comment: "")
    }
    
    struct Welcome {
        static let title = NSLocalizedString("welcome_title", comment: "Título de bienvenida")
        static let subtitle = NSLocalizedString("welcome_subtitle", comment: "Subtítulo para registro y login")
        static let appleLoginError = NSLocalizedString("apple_login_error", comment: "Error al iniciar sesión con Apple")
    }
    
    struct Profile {
        static let urls_generated = NSLocalizedString("urls_generated", comment: "")
        static let acquire_premium = NSLocalizedString("acquire_premium", comment: "")
        static let logout = NSLocalizedString("logout", comment: "")
        static let premium_status_yes = NSLocalizedString("premium_status_yes", comment: "")
        static let premium_status_no = NSLocalizedString("premium_status_no", comment: "")
    }
}
