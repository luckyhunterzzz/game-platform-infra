<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('email','password','password-confirm'); section>
  <#if section = "header">
    ${msg("registerTitle")}
  <#elseif section = "form">
    <form id="kc-register-form" class="${properties.kcFormClass!}" action="${url.registrationAction}" method="post">
      <div class="${properties.kcFormGroupClass!}">
        <div class="${properties.kcLabelWrapperClass!}">
          <label for="email" class="${properties.kcLabelClass!}">${msg("email")}</label>
        </div>
        <div class="${properties.kcInputWrapperClass!}">
          <input
            type="email"
            id="email"
            name="email"
            value="${(register.formData.email!'')}"
            class="${properties.kcInputClass!}"
            autocomplete="email"
            autofocus
            aria-invalid="<#if messagesPerField.existsError('email')>true</#if>"
          />
          <#if messagesPerField.existsError('email')>
            <span class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
              ${kcSanitize(messagesPerField.get('email'))?no_esc}
            </span>
          </#if>
        </div>
      </div>

      <#if passwordRequired??>
        <div class="${properties.kcFormGroupClass!}">
          <div class="${properties.kcLabelWrapperClass!}">
            <label for="password" class="${properties.kcLabelClass!}">${msg("password")}</label>
          </div>
          <div class="${properties.kcInputWrapperClass!}">
            <input
              type="password"
              id="password"
              name="password"
              class="${properties.kcInputClass!}"
              autocomplete="new-password"
              aria-invalid="<#if messagesPerField.existsError('password','password-confirm')>true</#if>"
            />
            <#if messagesPerField.existsError('password')>
              <span class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                ${kcSanitize(messagesPerField.get('password'))?no_esc}
              </span>
            </#if>
          </div>
        </div>

        <div class="${properties.kcFormGroupClass!}">
          <div class="${properties.kcLabelWrapperClass!}">
            <label for="password-confirm" class="${properties.kcLabelClass!}">${msg("passwordConfirm")}</label>
          </div>
          <div class="${properties.kcInputWrapperClass!}">
            <input
              type="password"
              id="password-confirm"
              name="password-confirm"
              class="${properties.kcInputClass!}"
              autocomplete="new-password"
              aria-invalid="<#if messagesPerField.existsError('password-confirm')>true</#if>"
            />
            <#if messagesPerField.existsError('password-confirm')>
              <span class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                ${kcSanitize(messagesPerField.get('password-confirm'))?no_esc}
              </span>
            </#if>
          </div>
        </div>
      </#if>

      <div class="${properties.kcFormGroupClass!} ${properties.kcFormSettingClass!}">
        <div id="kc-form-options" class="${properties.kcFormOptionsClass!}">
          <div class="${properties.kcFormOptionsWrapperClass!}">
            <span>
              <a href="${url.loginUrl}">${msg("backToLoginPlain")}</a>
            </span>
          </div>
        </div>
      </div>

      <div id="kc-form-buttons" class="${properties.kcFormGroupClass!}">
        <input
          class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}"
          type="submit"
          value="${msg("doRegister")}"
        />
      </div>
    </form>
  </#if>
</@layout.registrationLayout>
