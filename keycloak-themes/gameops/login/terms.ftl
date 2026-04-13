<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=false displayMessage=true; section>
  <#if section = "header">
    ${msg("acceptTermsTitle")}
  <#elseif section = "form">
    <div id="kc-terms-text">
      <p>${msg("acceptTermsDescription")}</p>

      <div class="${properties.kcFormGroupClass!}" style="margin-top: 1rem;">
        <ul style="margin: 0; padding-left: 1.25rem;">
          <li>
            <a href="http://localhost:3000/privacy" target="_blank" rel="noopener noreferrer">
              ${msg("privacyPolicyLabel")}
            </a>
          </li>
          <li>
            <a href="http://localhost:3000/terms" target="_blank" rel="noopener noreferrer">
              ${msg("termsOfUseLabel")}
            </a>
          </li>
        </ul>
      </div>
    </div>

    <form class="form-actions" action="${url.loginAction}" method="POST">
      <div class="${properties.kcFormGroupClass!}" style="margin-top: 1.25rem;">
        <label style="display: flex; gap: 0.65rem; align-items: flex-start; line-height: 1.5;">
          <input id="kc-accept-terms" type="checkbox" required />
          <span>${msg("termsAcceptLabel")}</span>
        </label>
      </div>

      <div id="kc-form-buttons" class="${properties.kcFormGroupClass!}" style="margin-top: 1.5rem;">
        <input
          class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonLargeClass!}"
          name="accept"
          id="kc-accept"
          type="submit"
          value="${msg("acceptButton")}"
        />
      </div>
    </form>
  </#if>
</@layout.registrationLayout>
