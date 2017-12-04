FROM microsoft/aspnetcore-build:2.0 AS builder
WORKDIR /build

# Copy csproj and restore as distinct layers
COPY . ./
WORKDIR /build/src/ZKEACMS.WebHost
RUN dotnet publish-zkeacms

# Copy Database
RUN mkdir /build/src/ZKEACMS.WebHost/bin/Release/PublishOutput/App_Data
RUN cp -f /build/DataBase/SQLite/Database-2.3.sqlite /build/src/ZKEACMS.WebHost/bin/Release/PublishOutput/App_Data/Database.sqlite
RUN cp -f /build/DataBase/SQLite/appsettings.json /build/src/ZKEACMS.WebHost/bin/Release/PublishOutput/appsettings.json

# Build runtime image
FROM microsoft/aspnetcore:2.0
WORKDIR /zkeacms
COPY --from=builder /build/src/ZKEACMS.WebHost/bin/Release/PublishOutput .
EXPOSE 80
ENTRYPOINT ["dotnet", "ZKEACMS.WebHost.dll"]