"""TheySell URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from . import views
from django.conf.urls.static import static
from django.conf import settings


urlpatterns = [
    path('admin/', admin.site.urls),
    path('home/', views.home, name='home'),
    path('login/', views.handleLogin, name='login'),
    path('signupuser/', views.handleSignUpUser, name='signupuser'),
    path('signupfarmer/', views.handleSignUpFarmer, name='signupfarmer'),
    path('logout/', views.handleLogout, name='logout'),
    path('shop/', views.shop, name='shop'),
    path('cart/', views.display_cart, name='displaycart'),
    path('ajax/cartUpdate/', views.update_cart, name='updatecart'),
    path('userprofile/', views.user_profile, name='userprofile'),
    path('allorders/', views.all_orders, name='allorders'),
    path('ordersummary/<str:order_id>', views.order_summary, name='ordersummary'),
    path('farmer/addgood', views.add_good, name='addgood'),
    path('farmer/saveGood', views.save_good, name='savegood'),
    path('farmer/home', views.farmer_home, name='farmerhome'),
    path('farmer/withdraw/<str:acc_address>', views.farmer_withdraw, name='farmerhome'),
    path('checkout/', views.checkout, name='checkout'),
]+static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
