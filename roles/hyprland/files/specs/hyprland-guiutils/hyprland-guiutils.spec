Name:           hyprland-guiutils
Version:        0.2.2
Release:        %autorelease -b2
Summary:        Hyprland utility apps
License:        BSD-3-Clause
URL:            https://github.com/hyprwm/hyprland-guiutils
Source:         %{url}/archive/v%{version}/%{name}-%{version}.tar.gz

# https://fedoraproject.org/wiki/Changes/EncourageI686LeafRemoval
ExcludeArch:    %{ix86}

BuildRequires:  cmake
BuildRequires:  gcc-c++

BuildRequires:  pkgconfig(hyprutils) >= 0.6.0
BuildRequires:  pkgconfig(hyprlang) >= 0.2.4
BuildRequires:  pkgconfig(hyprtoolkit) >= 0.4.0
BuildRequires:  pkgconfig(xkbcommon)

BuildRequires:  libdrm-devel
BuildRequires:  pixman-devel

# Qt-based predecessor
Obsoletes:      hyprland-qtutils < 1

%description
%{summary}.

%prep
%autosetup -p1

%build
%cmake
%cmake_build

%install
%cmake_install

%files
%license LICENSE
%doc README.md
%{_bindir}/hyprland-dialog
%{_bindir}/hyprland-donate-screen
%{_bindir}/hyprland-update-screen
%{_bindir}/hyprland-run
%{_bindir}/hyprland-welcome

%changelog
%autochangelog
