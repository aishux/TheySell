from django.db import models
from django.contrib.auth.models import Group
# Create your models here.


class WebUser(models.Model):
    id = models.TextField(primary_key=True)
    full_name = models.CharField(max_length=100)
    group = models.ForeignKey(Group, on_delete=models.CASCADE)
    request_seller = models.BooleanField(default=False)
    seller_id = models.CharField(max_length=200, default="", null=True, blank=True)
    aadhaar_link = models.URLField(default="", null=True, blank=True)
    account_address = models.CharField(max_length=50, default="", null=True, blank=True)

    def __str__(self):
        return self.full_name + "(" + str(self.group) + ")"


class Cart(models.Model):
    user = models.ForeignKey(WebUser, on_delete=models.CASCADE)
    cart = models.TextField(null=True, blank=True)